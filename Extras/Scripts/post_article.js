// Define the customizable parameters
const title = "RUCHANIE";
const content = "RU_CHA_NIE";

// Parse CSRF token and cookies from the current page
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const cookies = document.cookie;

// Construct the POST request
fetch("https://jbzd.com.pl/content/create/article", {
  method: "POST",
  mode: "cors",
  credentials: "include",
  headers: {
    "accept": "application/json",
    "accept-language": "en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7",
    "cache-control": "no-cache",
    "content-type": "multipart/form-data; boundary=----WebKitFormBoundary9FngenZ6BqLK93nU",
    "pragma": "no-cache",
    "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Linux\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "x-csrf-token": csrfToken,
    "x-xsrf-token": cookies
  },
  referrer: "https://jbzd.com.pl/oczekujace",
  referrerPolicy: "strict-origin-when-cross-origin",
  body: `------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="additional[0][id]"\r\n\r\n7u4SyfrBbkGVTo38\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="additional[0][type]"\r\n\r\narticle\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="additional[0][content][description]"\r\n\r\n${content}\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="title"\r\n\r\n${title}\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="description"\r\n\r\n\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="state"\r\n\r\nhumor\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="mca"\r\n\r\nfalse\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="mero"\r\n\r\nfalse\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="mature"\r\n\r\nfalse\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="search"\r\n\r\n\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="tags[0]"\r\n\r\ne\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="linking[url]"\r\n\r\n\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="linking[title]"\r\n\r\n\r\n------WebKitFormBoundary9FngenZ6BqLK93nU\r\nContent-Disposition: form-data; name="linking[description]"\r\n\r\n\r\n------WebKitFormBoundary9FngenZ6BqLK93nU--\r\n`
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
