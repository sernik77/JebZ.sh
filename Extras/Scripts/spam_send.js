// Replace X with the number of times you want to loop
const X = 10; // Example: Loop 10 times

for (let i = 0; i < X; i++) {
  // Place your code here that you want to execute X times
  yourCodeHere();
  // Example: console.log('This is loop iteration ' + i);
  // Define the customizable parameters
function clickSubmitButton() {
    // Find the button by its class name and type attribute
    var buttons = document.querySelectorAll('button.btn-submit[type="submit"]');
    // Filter buttons to find the one with the text "Dodaj"
    var targetButton = Array.from(buttons).find(button => button.textContent.trim() === "Dodaj");
    
    // Check if the button is found
    if(targetButton) {
        // Click the button
        targetButton.click();
        console.log('Button clicked successfully!');
    } else {
        // If no button is found, log an error message
        console.error('Button not found');
    }
}

// Run the function to click the button
clickSubmitButton();

}

function yourCodeHere() {
  // Replace this example function with your actual code
  console.log('Executing piece of code');
}
