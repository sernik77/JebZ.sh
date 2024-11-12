fetch("https://jbzd.com.pl/losowe", {
  headers: {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "accept-language": "en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7",
    "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Linux\"",
    "sec-fetch-dest": "document",
    "sec-fetch-mode": "navigate",
    "sec-fetch-site": "same-origin",
    "sec-fetch-user": "?1",
    "upgrade-insecure-requests": "1"
  },
  referrer: "https://jbzd.com.pl/losowe",
  referrerPolicy: "strict-origin-when-cross-origin",
  body: null,
  method: "GET",
  mode: "cors",
  credentials: "include"
}).then(response => {
  if (response.ok) {
    return response.text();
  }
  throw new Error('Network response was not ok.');
}).then(html => {
  document.body.innerHTML = html; // Replace the entire body of the page with the response
}).catch(error => {
  console.error('There has been a problem with your fetch operation:', error);
});
