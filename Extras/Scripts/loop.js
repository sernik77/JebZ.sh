// Replace X with the number of times you want to loop
const X = 10; // Example: Loop 10 times

for (let i = 0; i < X; i++) {
  // Place your code here that you want to execute X times
  yourCodeHere();
  // Example: console.log('This is loop iteration ' + i);
  // Define the customizable parameters
function postCommentAutomatically(comment) {
  // Extract the content ID from the URL using a regular expression
  // This regex assumes the content ID is always a sequence of digits following '/obr/'
  const contentIDMatch = window.location.href.match(/\/obr\/(\d+)/);
  if (!contentIDMatch) {
    console.error('Content ID could not be extracted from the URL.');
    return;
  }
  const contentID = contentIDMatch[1];

  // Dynamically construct the URL based on the extracted content ID
  const url = `https://jbzd.com.pl/comment/content/create/${contentID}`;

  // Attempt to dynamically extract the CSRF token from the page
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

  // Prepare the form data
  let formData = new FormData();
  formData.append("comment", comment);

  // Setup and execute the fetch request
  fetch(url, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'X-CSRF-Token': csrfToken,
      'X-Requested-With': 'XMLHttpRequest',
    },
    body: formData,
    credentials: 'include'
  })
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
  })
  .then(data => console.log(data))
  .catch(error => console.error('Error posting comment:', error));
}

// Example usage, automatically extracting content ID from the URL:
postCommentAutomatically('https://shorturl.at/jmLU0');
}

function yourCodeHere() {
  // Replace this example function with your actual code
  console.log('Executing piece of code');
}
