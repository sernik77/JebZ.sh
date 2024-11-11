### Extra pierdoły:

### Snippets:
Pobierz losowy obrazek 1000 x 1000px \
```wget https://picsum.photos/1000```

=========

### JS Snippets:
> Anti refresh / redirect tab lock.
```js
window.onbeforeunload = function(event) {
  event.preventDefault();
  event.returnValue = 'Are you sure you want to leave?';
  return 'Are you sure you want to leave?';
};
```
> Basic payload Vue
```vue
{{ alert("UwU") }}
```
> Basic payload in-element
```vue
<div v-html="'<script>alert(\"UwU\")<\/script>'"></div>
```

> Parse tokens and cookies in browser for fetch requests
```js
// Parse CSRF token and cookies from the current page
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  const cookies = document.cookie;

if (!csrfToken) {
  throw new Error("Could not retrieve CSRF token.");
}

// headers
          headers: {
            "accept": "application/json",
            "x-csrf-token": csrfToken,
            "x-xsrf-token": cookies,
            "X-Requested-With": "XMLHttpRequest",
            "cache-control": "no-cache",
            "pragma": "no-cache",
            "credentials": "include"
          }
```
\
\
\
\
\
\
.


**Alternatywne kryptonimy projektu xDDD**
> DUPA - Dzidowy Uniwersalny Pakiet Automatyzacji
