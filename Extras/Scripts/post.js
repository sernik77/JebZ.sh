// Define the customizable parameters
const title = "Your Image Title";
const content = "Your Image Description";
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

// Create a new FormData object
const form = new FormData();

// Append form fields
form.append('title', title);
form.append('description', content);
form.append('state', 'humor-memy');
form.append('mca', false);
form.append('mero', false);
form.append('mature', false);
form.append('search', '');
form.append('tags[0]', 'your_tag_here'); // Adjust according to actual tag inputs

// Specify the file to include
const fileInput = document.getElementById('userFile');
const selectedFile = new File(["file content"], "fsdfsdf.png", { type: "image/png" }); // Replace with your file content and name

// Check if a file is selected
if (fileInput && selectedFile) {
    // Append the selected file with the field name "Obrazek"
    form.append('Obrazek', selectedFile);
}

// Fetch request with FormData
fetch("https://jbzd.com.pl/content/create/image", {
    method: "POST",
    mode: "cors",
    credentials: "include",
    headers: {
        "accept": "application/json",
        "accept-language": "en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7",
        "cache-control": "no-cache",
        "pragma": "no-cache",
        "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Linux\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-csrf-token": csrfToken, // Dynamically obtained CSRF token
        "x-xsrf-token": "eyJpdiI6IjR2WjhwYXB4Q0pLVjdNOVZNQ1FBclE9PSIsInZhbHVlIjoiVmk5alpJSEJ0ZVI0MGRjNG9JMzF4QUUrWE1Gazg1SVJDV2QxMUdWWU8wREhvTjBtdHlSV0pydkF1U0xaWXNNYiIsIm1hYyI6IjU3OTE2Nzg0ODlmMmU0Y2U1MWJiMzNjNjQ1MGE0MDZlYmVkZGM2NDJkZDhhYTIyYjk4Y2M4ZmVlMGFhMmVhMWEifQ=="
    },
    body: form,
    referrer: "https://jbzd.com.pl/oczekujace",
    referrerPolicy: "strict-origin-when-cross-origin",
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error('Error:', error));
