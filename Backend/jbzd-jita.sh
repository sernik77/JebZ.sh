#!/bin/bash

# JBZD-JITA ~ Just In Time Alert! Monitoruj X ostatnich komentarzy danego użytkownika, i porównuj najnowszy response z poprzednim, jeśli jest różnica, wyślij nowy w pliku webhookiem na discorda. By sraniox  

# =========================== KONFIGURACJA ===========================
# Wiadomosc do alerta
MSG='# VERTRAGT'
# URL Requesta
URL="https://jbzd.com.pl/comment/user/listing/1204869?page=1&per_page=10&sort=newest"
# Ciastko clienta (curl -b)
COOKIE='remember_web_59ba3...'
# Discord Webhook - [Alert RCB]
WEBHOOK='https://discord.com/api/webhooks/1378482431933284372/jr62FzHmDkmb0QiP_D_7pH0GBKeEAnxJAm0zFtaH2ffdGvl7tB-XJFpfQrv3THiK8eL0'
# ========================== LOGIC ====================================
while true; do
sleep 1
# Pobierz komentarze
curl "$URL" \
  -H 'accept: application/json' \
  -H 'x-csrf-token: ZCrmR3UYeGlrnQxzdEsJma2vftatt5muLtLD4lhI' \
  -H 'x-requested-with: XMLHttpRequest' \
  -b "$COOKIE" \
  -o new.json
# Prostownik do JSONA
jq . new.json > pretty.json 2>/dev/null || cp new.json pretty.json
# Zostaw tylko linijki z '"comment":'
grep '"comment":' pretty.json > parsed.json
# Wyjeb spacje z początku każdej linijki
cut -c9- parsed.json > filtered.json
# If filtered.json differs from recent.json, send to webhook
if ! cmp -s filtered.json recent.json; then
    curl -F "payload_json={\"content\":\"$MSG\"}" \
         -F "file1=@filtered.json" \
         "$WEBHOOK"
    dt=$(date +"%H%M%S")
    mkdir -p old
    mv recent.json "old/recent-$dt.json"
    mv pretty.json "old/pretty-$dt.json"
    mv filtered.json recent.json
fi
# Cleanup
rm -f parsed.json
done
