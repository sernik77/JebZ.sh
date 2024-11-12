import discord
from discord.ext import commands
import requests
import re
import os

intents = discord.Intents.default()
intents.messages = True

bot = commands.Bot(command_prefix='/', intents=intents)

@bot.command()
async def jbzdlosowe(ctx):
    # The URL of the page to scrape
    URL = "https://jbzd.com.pl/losowe"

    # Fetch HTML content of the page
    response = requests.get(URL)
    if response.status_code != 200:
        await ctx.send("Failed to fetch data from the website.")
        return

    # Adjusted regular expression to exclude simple filenames like 'image.jpg'
    # and focus on longer, more randomized names
    media_urls = re.findall(r'(https?://[^\s]+?\b(?!image\.jpg)[a-zA-Z0-9_-]{5,}\.(jpg|png|gif|mp4))', response.text)

    # Debug: Print extracted URLs
    print("Extracted URLs:", media_urls)

    # Download the first media file (or a specific one if needed)
    if media_urls:
        media_url = media_urls[0]
        try:
            media_content = requests.get(media_url).content
            with open("temp_media", "wb") as file:
                file.write(media_content)

            # Send the media file
            with open("temp_media", "rb") as file:
                await ctx.send(file=discord.File(file, "image.jpg"))

            # Clean up local storage
            os.remove("temp_media")
        except requests.exceptions.RequestException as e:
            print(f"Error downloading media: {e}")
            await ctx.send("Failed to download the media.")
    else:
        await ctx.send("No media found.")

# Enter your Discord bot token here
bot.run('MTEwNDE3MTkyNDAxMzE4NzA3Mg.Gfen6q.Hy5SXRkfls2x_Mcd0xn3tw_gqiF_e3VcOLZEbw')

