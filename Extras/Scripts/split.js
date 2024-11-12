const sharp = require('sharp');

// The input image file
const inputImage = process.argv[2];

// Function to split the image into four parts
async function splitImage(imagePath) {
  try {
    // Get metadata (width and height) of the image
    const metadata = await sharp(imagePath).metadata();

    const width = metadata.width;
    const height = metadata.height;

    // Calculate half width and half height
    const halfWidth = width / 2;
    const halfHeight = height / 2;

    // Define the output files
    const outputFiles = [
      { name: 'top_left.png', x: 0, y: 0 },
      { name: 'top_right.png', x: halfWidth, y: 0 },
      { name: 'bottom_left.png', x: 0, y: halfHeight },
      { name: 'bottom_right.png', x: halfWidth, y: halfHeight },
    ];

    // Split the image into four parts
    outputFiles.forEach(file => {
      sharp(imagePath)
        .extract({ left: file.x, top: file.y, width: halfWidth, height: halfHeight })
        .toFile(file.name)
        .then(() => console.log(`Output saved as ${file.name}`))
        .catch(err => console.error(`Error processing ${file.name}:`, err));
    });
  } catch (err) {
    console.error('An error occurred:', err);
  }
}

// Run the function with the provided image
splitImage(inputImage);
