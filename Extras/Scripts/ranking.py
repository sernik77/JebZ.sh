from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import json
import os

# Setup WebDriver
driver = webdriver.Chrome()  # Ensure chromedriver is in PATH or specify the path

def super_fast_scroll():
    """
    Function to scroll down the page by emulating PAGE_DOWN and ARROW_DOWN key presses.
    """
    body = driver.find_element(By.TAG_NAME, "body")
    while True:
        body.send_keys(Keys.PAGE_DOWN)  # Emulates pressing the page down key
        body.send_keys(Keys.ARROW_DOWN)  # Emulates pressing the arrow down key
        time.sleep(1)  # Short delay to allow page loading

def fetch_data(existing_data):
    """
    Function to fetch ranking data from the page and append it to the existing data.
    """
    user_elements = driver.find_elements(By.CSS_SELECTOR, "li > a[href*='/uzytkownik/']")
    new_data_found = False
    for element in user_elements:
        rank = element.find_element(By.CSS_SELECTOR, ".ranking-models-rank").text.strip().split('.')[0]
        nickname = element.find_element(By.CSS_SELECTOR, ".ranking-models-name").text.strip()
        score = element.find_element(By.CSS_SELECTOR, ".ranking-models-points").text.strip()
        user_data = {'rank': rank, 'nickname': nickname, 'score': score}
        
        if user_data not in existing_data:
            existing_data.append(user_data)
            new_data_found = True
            
    if new_data_found:
        # Append new data to JSON file
        with open('ranking.json', 'w') as file:
            json.dump(existing_data, file, indent=4)

# Load existing data if available
ranking_file = 'ranking.json'
if os.path.exists(ranking_file):
    with open(ranking_file, 'r') as file:
        existing_data = json.load(file)
else:
    existing_data = []

# Navigate to the ranking page
driver.get('https://jbzd.com.pl/ranking')

# Start the scrolling in a separate thread
from threading import Thread
scroll_thread = Thread(target=super_fast_scroll, daemon=True)
scroll_thread.start()

try:
    # Periodically fetch data until manually stopped or an error occurs
    while True:
        fetch_data(existing_data)
        time.sleep(3)  # Adjust as needed to manage load and avoid being blocked
except KeyboardInterrupt:
    print("\nScript execution halted by user.")
finally:
    driver.quit()
    if scroll_thread.is_alive():
        scroll_thread.join()
