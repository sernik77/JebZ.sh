from selenium import webdriver
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.common.by import By
from webdriver_manager.firefox import GeckoDriverManager
import asyncio
import re
import time

async def get_ranking_with_selenium(url, output_file, timeout=20):
    options = FirefoxOptions()
    options.headless = True  # Run in headless mode (no GUI)

    # Initialize the driver
    with webdriver.Firefox(service=FirefoxService(GeckoDriverManager().install()), options=options) as driver:
        driver.get(url)

        start_time = time.time()
        all_ranking_data = []
        captured_users = set()  # Keep track of users already captured
        last_height = driver.execute_script("return document.body.scrollHeight")

        try:
            while True:
                # Scroll down to the bottom of the page
                driver.execute_script("window.scrollTo(-100, document.body.scrollHeight);")

                # Wait 1 second to load page
                await asyncio.sleep(0.1)

                # Check for timeout
                if time.time() - start_time > timeout:
                    break

                # Calculate new scroll height and compare with last scroll height
                new_height = driver.execute_script("return document.body.scrollHeight")
                if new_height == last_height:
                    break
                last_height = new_height

                # Specific selector for ranking elements
                selector = ".ranking-models li"  # Example selector, adjust based on actual page structure

                # Extract ranking information
                elements = driver.find_elements(By.CSS_SELECTOR, selector)
                for element in elements:
                    text = element.text.strip()
                    # Assuming the format is always "RankUsernameScore"
                    rank, username, score = text.split('\n')

                    # Debugging the rank value
                    print(f"Original rank string: {rank}")

                    # Extracting only the numeric part of the rank and ensuring it's not empty
                    rank = re.sub(r'[^0-9]', '', rank)
                    if rank.isdigit():
                        rank = int(rank)
                    else:
                        print(f"Invalid rank format: {rank}")
                        continue

                    # Add the user only if they haven't been captured before
                    if username not in captured_users:
                        all_ranking_data.append((rank, username, score))
                        captured_users.add(username)

        except KeyboardInterrupt:
            print("\nInterrupted by user...")

        # Sorting data by rank and preparing for output
        sorted_data = sorted(all_ranking_data, key=lambda x: x[0])
        output_str = "\n".join([f"{rank}\n{username}\n{score}\n" for rank, username, score in sorted_data])

        # Save sorted rankings to file
        with open(output_file, "w") as file:
            file.write(output_str)
        print("Ranking saved to", output_file)

# Usage
url = 'https://jbzd.com.pl/ranking'
output_file = "ranking2.txt"
get_ranking_with_selenium(url, output_file)

if __name__ == "__main__":
    url = 'https://jbzd.com.pl/ranking'  # TODO: Replace with your URL
    output_file = 'ranking2.txt'  # TODO: Replace with your output file path
    asyncio.run(get_ranking_with_selenium(url, output_file))
