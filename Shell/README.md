# Shell scripts (cURL)
> Zestaw skryptów na bazie cURL

## Skrypty:
- `register.sh` - Zarejestruj nowe konto
- `confirm-phone.sh` - Potwierdź numer telefonu
- `create-image.sh` - Wrzuć mema z obrazkiem
- `priv-start.sh` - Rozpocznij nową rozmowę prywatną
- `priv-send.sh` - Wyślij wiadomość w rozmowie prywatnej 
- `comment.sh` - Wyślij komentarz pod postem
- `user-modify.sh` - Dodaj na czarną listę lub do obserwowanych
- `badge.sh` - Daj odznakę
- `load-comments.sh` - Pobierz komentarze użytkownika
- `vote-comment.sh` - Oceń komentarz (plus / minus)
- `vote-user.sh` - Daj plus na profil
- `random-meme.sh` - Pobierz memy z /losowe
- `text-create.sh` - Wrzuć wrzute tekstową, np z pliku
- `find-uid.sh` - Znajdź ID Użytkownika

### Extra pierdoły:
Pobierz losowy obrazek 1000 x 1000px \
```wget https://picsum.photos/1000```

### JS Snippets:
> Anti refresh / redirect tab lock.
```
window.onbeforeunload = function(event) {
  event.preventDefault();
  event.returnValue = 'Are you sure you want to leave?';
  return 'Are you sure you want to leave?';
};
```
> Basic payload Vue
```
{{ alert("UwU") }}
```
> Basic payload in-element
```
<div v-html="'<script>alert(\"UwU\")<\/script>'"></div>
```
