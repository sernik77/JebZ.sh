fetch("https://jbzd.com.pl/badge/comment/give/26159912", {
  headers: {
    "accept": "application/json",
    "accept-language": "en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7",
    "content-type": "application/json;charset=UTF-8",
    "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Linux\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    // Note: "x-csrf-token" and "x-xsrf-token" might need to be obtained from the current session
  },
  referrer: "https://jbzd.com.pl/uzytkownik/serainox/komentarze",
  referrerPolicy: "strict-origin-when-cross-origin",
  body: "{\"type\":\"gold\"}",
  method: "POST",
  mode: "cors",
  credentials: "include"
}).then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
