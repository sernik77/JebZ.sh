function psr(s,fz,ap){fetch(location.href.slice(0,19)+`/ranking/get?page=`+(s||1)+`&per_page=`+25).then(r=>r.json()).then(d=>fz(cd(d),ap)).catch(r=>fz(-1,ap))}
function cd(d){if(typeof d!="object"){return -1}if(d.status!="success"){return -1}return( d.rankings||{}).data||-1}
function u(d,ap)
{
    if(!d|| !Array.isArray(d)){return setTimeout(()=>{psr(ap.s,u,ap)},pp+1107)}
    for(let w=0;w<d.length;w++){if(d[w].points==0){break}let tym={p:d[w].points,n:d[w].model.name,k:d[w].model.color,id:d[w].model.id,a:d[w].model.avatar_url.small,s:d[w].model.slug,u:d[w].model.url};zr[d[w].rank]=tym;oe=d[w].points}
    if(oe!=-1&&oe<kn){return zapisz()}ap.s++;setTimeout(()=>{psr(ap.s,u,ap)},pp+327)
    console.clear()
    console.log("żeby zapisać ranking już teraz wpisz w konsolę: zapisz()")
    console.log("zapis nie powoduje przerwania pobierania rankingu")
    console.log("zapisanych pozycji jest już: "+zr.length)
    console.log("zapisane pozycje kończą się użytkownikiem "+zr[zr.length-1].n)
    console.log("liczba jego plusów wynosi: "+oe)
}
let kn=Number(prompt("na ilu plusach zatrzymać spisywanie rankingu? nie wpisuj 0 bo 0 plusów nigdy się nie kończy."))||5;if (kn<1){kn=1}
if (location.href.slice(8,12)=="jbzd"){setTimeout(()=>{u(0,{s:1})},500)}else{alert("skrypt działa tylko na stronie JBZD")}
let oe=-1
let zr=[72]
let pp=500
function zapisz()
{
    let s=["",""]
    for (let a=1 ; a<zr.length ; a++)
    {
        s[0]+=a+".\t"+zr[a].n+":\t"+zr[a].p+"\r\n"
        let k=""
        for (let b=1 ; b<5 ; b++){if (["","#666666","#8BD82B","#DE2221","F0FF0a"][b]==zr[a].k){k=",k:"+b;break}}
        let aw=``
        if (zr[a].a!="https://i1.jbzd.com.pl/users/default.jpg"){aw=`,a:`+JSON.stringify(zr[a].a.slice(35))}
        s[1]+=`{n:`+JSON.stringify(zr[a].n)+`,s:`+JSON.stringify(zr[a].s)+`,p:`+zr[a].p+`,id:`+zr[a].id+`,u:`+JSON.stringify(zr[a].u.slice(31))+k+aw+`},`
    }
    zapiszStringa(s[0],"ranking-tekst "+dzisiejszaData())
    s[1]=usunZnaki(s[1],["<",">"])
    s[1]="<!DOCTYPE html><html><head><title>ranking JBZD dnia "+dzisiejszaData()+"</title><meta charset=\"utf-8\"/>\r\n<style type=\"text/css\">\r\n    .pozycja {width: 500px; background: #313131; padding: 7px; align-items: center; display: flex; margin:2px; text-decoration: none; color:white;}\r\n .rank {display: inline-block; width: 57px; font-weight: 700;}\r\n   .rank::befor{content: \"    \"}\r\n .rank::after{content: \".\"}\r\n    .nick {display: inline-block; width: 327px;}\r\n    .avatar1 {display: inline-block; margin: 0 17px;}\r\n   .avatar2 {border-radius: 47%;}\r\n  .plusy {display: inline-block; color: #f0cc00; font-weight: 700;}\r\n   .plusy::before {content: \"+ \"}\r\n</style>\r\n<script type=\"text/javascript\">\r\nlet d=["+s[1]+"]\r\nlet s=\"\"\r\nfor(let a=0 ; a<d.length ; a++){s+=pozycja(a+1,d[a])}\r\ndocument.write(s)\r\nfunction pozycja(nr,d)\r\n{\r\n    let a=`https://i1.jbzd.com.pl/users/small/`+(d.a||\"30J8yZ0ma3oxyVtQJVxIYtxRhGFITNRX.jpg\");if (!d.a){a=`https://i1.jbzd.com.pl/users/default.jpg`}\r\n setTimeout(()=>{document.getElementById(\"u\"+nr).innerHTML='<img class=\"avatar2\" src=\"'+a+' \"width=\"25\" height=\"25\">'},nr*50+3000)\r\n return '<a href=\"https://jbzd.com.pl/uzytkownik/'+d.u+'\" class=\"pozycja\"><div class=\"rank\" style=\"color:'+([\"\",\"#666666\",\"#8BD82B\",\"#DE2221\",\"F0FF0a\"][d.k]||\"white\")+'\">'+nr+'</div><div class=\"avatar1\" id=\"u'+nr+'\"></div><div class=\"nick\">'+d.n+' &nbsp; <span style=\"opacity:0.07;\">'+(d.s||\"\")+' &nbsp '+(d.id||\"\")+'</span></div><div class=\"plusy\">'+(d.p||\"?\")+'</div></a>'\r\n}\r\n</script><body id=\"boody\" style=\"font-family: Open Sans,sans-serif; background-color: #252525; color:white; font-size: 14px;\"></body></html>\r\n"
    //s[1]="<!DOCTYPE html><html><head><title>ranking JBZD dnia "+dzisiejszaData()+"</title><meta charset=\"utf-8\"/>\r\n<style type=\"text/css\">\r\n  .pozycja {width: 500px; background: #313131; padding: 7px; align-items: center; display: flex; margin:2px; text-decoration: none; color:white;}\r\n .rank {display: inline-block; width: 57px; font-weight: 700;}\r\n   .rank::befor{content: \"\t\"}\r\n   .rank::after{content: \".\"}\r\n    .nick {display: inline-block; width: 327px;}\r\n    .avatar {display: inline-block; border-radius: 47%; margin: 0 17px;}\r\n    .plusy {display: inline-block; color: #f0cc00; font-weight: 700;}\r\n   .plusy::before {content: \"+ \"}\r\n</style>\r\n<script type=\"text/javascript\">\r\nlet d=["+s[1]+"];let s=``;for (let a=0 ; a<d.length ; a++){s+=pozycja(a+1,d[a])};document.write(s)\r\nfunction pozycja(nr,d){let a=`https://i1.jbzd.com.pl/users/small/`+(d.a||\"30J8yZ0ma3oxyVtQJVxIYtxRhGFITNRX.jpg\");if (!d.a){a=`https://i1.jbzd.com.pl/users/default.jpg`};return '<a href=\"https://jbzd.com.pl/uzytkownik/'+d.u+'\" class=\"pozycja\"><div class=\"rank\" style=\"color:'+([\"\",\"#666666\",\"#8BD82B\",\"#DE2221\",\"F0FF0a\"][d.k]||\"white\")+'\">'+nr+'</div><img class=\"avatar\" src=\"'+a+'\"width=\"25\" height=\"25\"><div class=\"nick\">'+d.n+' &nbsp; <span style=\"opacity:0.07;\">'+(d.s||\"\")+' &nbsp '+(d.id||\"\")+'</span></div><div class=\"plusy\">'+(d.p||\"?\")+'</div></a>'}\r\n</script><body id=\"boody\" style=\"font-family: Open Sans,sans-serif; background-color: #252525; color:white; font-size: 14px;\"></body></html>"
    zapiszStringa(s[1],"ranking-html "+dzisiejszaData()+" (dopisz zamiast tego po kropce html)")
}
function zapiszStringa(string,nazwa)
{
  (function(a,b){if("function"==typeof define&&define.amd)define([],b);else if("undefined"!=typeof exports)b();else{b(),a.FileSaver={exports:{}}.exports}})(this,function(){"use strict";function b(a,b){return"undefined"==typeof b?b={autoBom:!1}:"object"!=typeof b&&(console.warn("Deprecated: Expected third argument to be a object"),b={autoBom:!b}),b.autoBom&&/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(a.type)?new Blob(["\uFEFF",a],{type:a.type}):a}function c(a,b,c){var d=new XMLHttpRequest;d.open("GET",a),d.responseType="blob",d.onload=function(){g(d.response,b,c)},d.onerror=function(){console.error("could not download file")},d.send()}function d(a){var b=new XMLHttpRequest;b.open("HEAD",a,!1);try{b.send()}catch(a){}return 200<=b.status&&299>=b.status}function e(a){try{a.dispatchEvent(new MouseEvent("click"))}catch(c){var b=document.createEvent("MouseEvents");b.initMouseEvent("click",!0,!0,window,0,0,0,80,20,!1,!1,!1,!1,0,null),a.dispatchEvent(b)}}var f="object"==typeof window&&window.window===window?window:"object"==typeof self&&self.self===self?self:"object"==typeof global&&global.global===global?global:void 0,a=f.navigator&&/Macintosh/.test(navigator.userAgent)&&/AppleWebKit/.test(navigator.userAgent)&&!/Safari/.test(navigator.userAgent),g=f.saveAs||("object"!=typeof window||window!==f?function(){}:"download"in HTMLAnchorElement.prototype&&!a?function(b,g,h){var i=f.URL||f.webkitURL,j=document.createElement("a");g=g||b.name||"download",j.download=g,j.rel="noopener","string"==typeof b?(j.href=b,j.origin===location.origin?e(j):d(j.href)?c(b,g,h):e(j,j.target="_blank")):(j.href=i.createObjectURL(b),setTimeout(function(){i.revokeObjectURL(j.href)},4E4),setTimeout(function(){e(j)},0))}:"msSaveOrOpenBlob"in navigator?function(f,g,h){if(g=g||f.name||"download","string"!=typeof f)navigator.msSaveOrOpenBlob(b(f,h),g);else if(d(f))c(f,g,h);else{var i=document.createElement("a");i.href=f,i.target="_blank",setTimeout(function(){e(i)})}}:function(b,d,e,g){if(g=g||open("","_blank"),g&&(g.document.title=g.document.body.innerText="downloading..."),"string"==typeof b)return c(b,d,e);var h="application/octet-stream"===b.type,i=/constructor/i.test(f.HTMLElement)||f.safari,j=/CriOS\/[\d]+/.test(navigator.userAgent);if((j||h&&i||a)&&"undefined"!=typeof FileReader){var k=new FileReader;k.onloadend=function(){var a=k.result;a=j?a:a.replace(/^data:[^;]*;/,"data:attachment/file;"),g?g.location.href=a:location=a,g=null},k.readAsDataURL(b)}else{var l=f.URL||f.webkitURL,m=l.createObjectURL(b);g?g.location=m:location.href=m,g=null,setTimeout(function(){l.revokeObjectURL(m)},4E4)}});f.saveAs=g.saveAs=g,"undefined"!=typeof module&&(module.exports=g)});
    var blob = new Blob([string], { type: 'text/plain;charset=utf-8' });
    saveAs(blob, nazwa+'.txt');
}
function dzisiejszaData()
{
  let tym=new Date
  let string=""
  string+=tym.getDate().toString().padStart(2, '0')+" "
  string+=["styczeń","luty","marzec","kwiecień","maj","czerwiec","lipiec","sierpień","wrzesień","październik","listopad","grudzień"][tym.getMonth()]+" "
  string+=tym.getFullYear().toString().padStart(2, '0')+"r. godzina "
  string+=tym.getHours().toString().padStart(2, '0')+""
  //string+=tym.getMinutes().toString().padStart(2, '0')+""
  return string
}
function usunZnaki(tekst,znaki)
{
    let s=""
    for (let a=0 ; a<tekst.length ; a++)
    {
        let q=1
        for (let b=0 ; b<znaki.length ; b++){if (tekst[a]==znaki[b]){q=0;break}}
        if (q){s+=tekst[a]}
    }
    return s
}
