// Function to dynamically extract the CSRF token from a meta tag
function getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
}

// Function to extract a cookie value by name for any other needed tokens
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Adjust the cookie name if you're using a different token for XSRF protection
const xsrfToken = getCookie('XSRF-TOKEN'); // Replace 'XSRF-TOKEN' with the actual cookie name

fetch("https://jbzd.com.pl/comment/vote/26276927", {
  method: "POST",
  headers: {
    "Accept": "application/json",
    "Content-Type": "application/json;charset=UTF-8",
    "X-CSRF-Token": getCsrfToken(), // Dynamically fetched CSRF token
    "X-Requested-With": "XMLHttpRequest",
    // Add "x-xsrf-token": xsrfToken, if your API expects an XSRF token in headers
  },
  body: JSON.stringify({"for":1}),
  credentials: "include", // Necessary for including cookies in the request for same-origin or when allowed by CORS
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error('Error:', error));
