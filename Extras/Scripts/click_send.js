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
