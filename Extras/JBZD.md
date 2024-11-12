# Specjały do dzidki

## Ciekawostki:
- Cytowanie "pustych" (zsanityzowanych) komentarzy wciąż wyświetla ukrytą treść \
- Dodanie obrazka przy tworzeniu wpisu na mikro, po czym kliknięcie go, wypluwa hash w tekście \
`[image hash=695f9f0c-73d3-48c4-927b-543f9be80679]`, co ciekawe hash można modyfikować bez naruszania obrazka
- Dodanie obrazka jako hash na mikro wielokrotnie, dodaje obrazek wielokrotnie. (hash określa pozycje obrazka, np hash w cudzysłowiu, będzie obrazkiem cytowanym)
- Ankiety na mikro się nie sanityzują
- `@[{{]`, `@[}}]` jest na mikro sanityzowany po edycji, a na dzidce nie
- Na mikro można zformatować oznaczenie np ```**__@[op]__**``` i dalej działa
- Oznaczenie kogoś na mikro przez `@[nick]` tworzy odnośnik do jego profilu na mikroblogu.
- 
 

## Pytania za 100 punktów
- Czy da się podmienić zawartość strony już po zembedowaniu bez tracenia embeda?
- Gdzie uda wepchać się xss.svg zamiast obrazka?
- Co dzieje sie z gifami po dodaniu do komentarza?
- Czy jeśli złapie sie trakcji, to pojade jak tramwaj?
- Czy da sie przemycić XSS gifem na mikro? (exif)
- Czy da sie wrzucić 9999 super zamulających gifów 1x1px do jednego posta na mikro i wysadzić dzide?
- Czy da sie wrzucić .webm?



  
Embedowanie linków w komentarzach jako "użytkownika"
```
@[http://szmelc.com]
```

Omijanie 'blokady' linkowania przez DNS
```
http://www.szmelc.ip-dynamic.org/
```

Embedowanie podstron dzidy jako użytkownika
```
@[ustawienia]
@[wyloguj]
```

Sanityzacja całego komentarza???
```
{{ {{ {{ cokolwiek }} }} }}
```

# Potencjał na nadużycie:
```
[quote] X [/quote]
@[XYZ]
@op

// Dziwna sanityzacja mikrobloga zamnienia:
@[<] = @[lt]
@[>] = @[gt]
```
