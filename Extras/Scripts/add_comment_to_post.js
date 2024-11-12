const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
fetch('https://jbzd.com.pl/comment/content/create/228492', {
  method: 'POST',
  headers: {
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.9,pl-PL;q=0.8,pl;q=0.7',
    'Content-Type': 'application/x-www-form-urlencoded', // Changed for simplicity
    'X-CSRF-Token': csrfToken, // CSRF token for security
    'X-Requested-With': 'XMLHttpRequest',
    // Note: Cookies are handled automatically by the browser and should not be manually set in fetch API
  },
  body: new URLSearchParams({
    'comment': '@[ruchanie]'
  }).toString(),
  credentials: 'include' // Necessary to include cookies and authentication headers
}).then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
