
import requests
from bs4 import BeautifulSoup
import os
from urllib.parse import urljoin, urlparse
import re

def save_resource(url, session, base_path):
    """Saves the resource at the specified URL to the local directory structure."""
    try:
        response = session.get(url)
        # Check if the request was successful
        if response.status_code == 200:
            # Parse the path from the URL
            parsed_url = urlparse(url)
            path = parsed_url.path
            if not path:
                path = "/index.html"  # Default file name for root document
            elif path.endswith("/"):
                path += "index.html"  # Default file name for directory paths

            # Create a local path
            local_path = os.path.join(base_path, path.lstrip("/"))
            os.makedirs(os.path.dirname(local_path), exist_ok=True)

            # Write content to local path
            with open(local_path, "wb") as file:
                file.write(response.content)
            return True
        else:
            print(f"Failed to download {url}: Status code {response.status_code}")
            return False
    except requests.RequestException as e:
        print(f"Error downloading {url}: {e}")
        return False

def download_source_map(url, session, base_path):
    """Downloads the source map and any associated files."""
    try:
        response = session.get(url)
        if response.status_code == 200:
            # Save the source map file
            source_map_path = urlparse(url).path
            local_source_map_path = os.path.join(base_path, source_map_path.lstrip("/"))
            os.makedirs(os.path.dirname(local_source_map_path), exist_ok=True)
            with open(local_source_map_path, "wb") as file:
                file.write(response.content)

            # Attempt to parse the source map and download associated files
            # Note: This is a simple implementation and might not work with all source maps
            source_map_data = response.json()
            if "sources" in source_map_data:
                for source in source_map_data["sources"]:
                    source_url = urljoin(url, source)
                    save_resource(source_url, session, base_path)
        else:
            print(f"Failed to download source map {url}: Status code {response.status_code}")
    except requests.RequestException as e:
        print(f"Error downloading source map {url}: {e}")

def modified_save_resource(url, session, base_path):
    """Modified save_resource function to handle source maps."""
    if save_resource(url, session, base_path):
        try:
            # Only check CSS and JS files for source maps
            if url.endswith(".css") or url.endswith(".js"):
                # Download the content to check for a source map URL
                response = session.get(url)
                if response.status_code == 200:
                    # Look for a sourceMappingURL comment
                    source_map_url_match = re.search(r"//# sourceMappingURL=(.+?)(?=\s*$)", response.text, re.MULTILINE)
                    if source_map_url_match:
                        source_map_url = source_map_url_match.group(1)
                        full_source_map_url = urljoin(url, source_map_url)
                        download_source_map(full_source_map_url, session, base_path)
        except requests.RequestException as e:
            print(f"Error checking for source map in {url}: {e}")

# Modify the scrape_site function to use the modified_save_resource
def modified_scrape_site(url, base_path="new-log"):
    """Modified scrape_site function to handle source maps."""
    session = requests.Session()
    response = session.get(url)

    if response.status_code != 200:
        print(f"Failed to retrieve the URL: {url}")
        return False

    # Create the base directory
    os.makedirs(base_path, exist_ok=True)

    # Save the main page
    modified_save_resource(url, session, base_path)

    # Parse for additional resources
    soup = BeautifulSoup(response.text, 'html.parser')
    for tag in soup.find_all(['link', 'script', 'img']):
        # Extract the URL of the resource
        if tag.name == 'link':
            resource_url = tag.get('href')
        elif tag.name == 'script':
            resource_url = tag.get('src')
        elif tag.name == 'img':
            resource_url = tag.get('src')
        else:
            continue

        if resource_url:
            full_url = urljoin(url, resource_url)
            modified_save_resource(full_url, session, base_path)

    return True

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        url = sys.argv[1]
        modified_scrape_site(url)
    else:
        print("Please provide a URL as an argument.")
