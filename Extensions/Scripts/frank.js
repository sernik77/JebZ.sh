function pobierzStroneRankingu(strona,funkcjaZwrotna,argumentyPrzelotowe){fetch(`https://jbzd.com.pl/ranking/get?page=`+(strona||1)+`&per_page=25`).then(r=>r.json()).then(d=>funkcjaZwrotna(czyszczenieDanych(d),argumentyPrzelotowe)).catch(r=>funkcjaZwrotna(-1,argumentyPrzelotowe))}
function pobierzKomentarze(id,strona,funkcjaZwrotna,argumentyPrzelotowe){fetch("https://jbzd.com.pl/comment/user/listing/"+id+"?page="+(strona||1)+"&per_page=25&sort=newest",{headers:{"x-requested-with":"XMLHttpRequest",}}).then(r=>r.json()).then(d=>funkcjaZwrotna(czyszczenieDanych(d),argumentyPrzelotowe)).catch(r=>funkcjaZwrotna(-1,argumentyPrzelotowe))}
function pobierzDaneZmikrobloga(id,funkcjaZwrotna,argumentyPrzelotowe){fetch("https://jbzd.com.pl/mikroblog/user/profile/"+id).then(r=>r.json()).then(d=>funkcjaZwrotna(czyszczenieDanych(d),argumentyPrzelotowe)).catch(r=>funkcjaZwrotna(-1,argumentyPrzelotowe))}
function czyszczenieDanych(dane)
{
    if (typeof dane=="object"){if (dane.status=="success")
    {
        if (dane.rankings){dane=dane.rankings;if (Array.isArray(dane.data)&&dane.last_page>0){return[dane.data,dane.last_page]}}
        if (dane.pagination){dane=dane.pagination;if (Array.isArray(dane.data)&&dane.last_page>0&&dane.total>-1){return[dane.data,dane.last_page,dane.total]}}
        if (dane.user){dane=dane.user;if (typeof dane=="object"){return dane}}
    }}
}
function poczekaj(funkcjaPoCzasie,argumenty,czas)
{
  czas=czas||3
  czas=czas*1000
  argumenty=argumenty||[]
  if (!Array.isArray(argumenty)){argumenty=[argumenty]}
  //funkcja uruchamia inną funkcję po losowym czasie. w domyśle około 3 sekundy
  {setTimeout(()=>{funkcjaPoCzasie(...argumenty)},(Math.random()*(czas*0.1))+(czas*0.95))}
}
function dodajDoDanych(brudneDane)
{
    let string="id:"+(brudneDane.id||`"?"`)+","
    string+=`nick:`+JSON.stringify(brudneDane.model.name||`?`)+`,`
    string+=`zawolanie:"`+(brudneDane.model.slug||`?`)+`",`
    string+=`kolor:"`+(brudneDane.model.color||`?`)+`",`
    string+=`awatar:"`+(brudneDane.model.avatar_url.large||`?`)+`",`
    string+="plusyProfilowe:"+(brudneDane.points||`0`)+",";ostatniePlusy=brudneDane.points
    string+="iloscKomentarzy:"+(brudneDane.iloscKomentarzy||`0`)+","
    string+=`dataPierwszegoKomentarza:"`+(brudneDane.dataPierwszegoKomentarza||`?`)+`",`
    string+=`dataOstatniegoKomentarza:"`+(brudneDane.dataOstatniegoKomentarza||`?`)+`",`
    string+="rangaMikroblogowa:"+(brudneDane.rangaMikroblogowa||`0`)+","
    if (brudneDane.admin){string+="admin:1,"}else{string+="admin:0,"}
    if (brudneDane.moderator){string+="moderator:1,"}else{string+="moderator:0,"}
    if (brudneDane.zbanowany){string+="zbanowany:1,"}else{string+="zbanowany:0,"}
    if (brudneDane.aktywny){string+="aktywny:1"}else{string+="aktywny:0"}
    string="dane["+brudneDane.rank+"]={"+string+"};\n"
    pobraneDane+=string
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
  string+=tym.getDate().toString().padStart(2, '0')+"."
  string+=tym.getMonth().toString().padStart(2, '0')+"."
  string+=tym.getFullYear().toString().padStart(2, '0')+"r. godz."
  string+=tym.getHours().toString().padStart(2, '0')+"."
  string+=tym.getMinutes().toString().padStart(2, '0')+""
  return string
}
function zapiszPobranedane()
{
    zapiszStringa(dzisiejszaData()+"\n\n"+pobraneDane,dzisiejszaData()+" ranking JBZD (JS)")
    let string='<!DOCTYPE html><html><head><title>ranking z dnia '+dzisiejszaData()+'</title><meta charset="utf-8" /><script type="text/javascript">let dane=[0]\n'+pobraneDane+';function pokazRanking(rodzajSegregowania){let ranking=segregowanie[rodzajSegregowania](dane);let string="";let string2="";let ilosc=Number(prompt("ile użytkowników wczytać? (wszystkich "+(dane.length-1)+")")||100)||100;for (let a=1 ; a<ranking.length ; a++){if (!ranking[a]||a>ilosc){break}string+=`<div style="width:586px; height:157px; background-color:#252525; margin:7px;">`;string+=`<img style="float:left; height:70px; margin:7px;" src="`+(ranking[a].awatar||"https://i1.jbzd.com.pl/users/default.jpg")+`" alt="">`;string+=`<div style="float:left; margin:7px;">`;string+=`<span style="color:white; font-size:14px;"><b>miejsce `+a+`:</b></span><br>`;string2+=`miejsce `+a+`: `+ranking[a].nick+`\n+`+ranking[a].plusyProfilowe+` `+ranking[a].iloscKomentarzy+`kom `+ranking[a].predkosc+`kom/d\n`;string+=`<span style="color:`+ranking[a].kolor+`; font-size:17px;"><b>`+ranking[a].nick+`</b></span>&nbsp;`;string+=`<span style="color:#2f2f2f; font-size:10px; opacity:0.1;">`+ranking[a].zawolanie+`&nbsp;ID:`+ranking[a].id+`&nbsp;`+ranking[a].kolor+`</span><br>`;string+=`<span style="color:#c5f77f; font-size:17px;"><b>+</b>`+ranking[a].plusyProfilowe+` `+kreski(ranking[a].plusyProfilowe,maksPlusow||1)+`</span><br>`;string+=`<span style="color:#7fd9f7; font-size:17px;">`+ranking[a].iloscKomentarzy+`kom `+kreski(ranking[a].iloscKomentarzy,makskomentarzy||1)+`</span><br>`;string+=`<span style="color:#bb7ff7; font-size:17px;">`+ranking[a].predkosc+`kom/d `+kreski(ranking[a].predkosc,maksPredkosc||0.01)+`</span><br>`;if (ranking[a].admin){string+=`<span style="color:#f0ff0a; font-size:17px;">Admin</span><br>`}if (ranking[a].moderator){string+=`<span style="color:#f0ff0a; font-size:17px;">Moderator</span><br>`}if (ranking[a].zbanowany){string+=`<span style="color:#b11c11; font-size:17px;">Zbanowany</span><br>`}if (!ranking[a].aktywny){string+=`<span style="color:#b11c11; font-size:17px;">Nieaktywny</span><br>`}string+=`<span style=""></span>`;string+=`</div>`;string+=`</div>`}document.getElementById("boody").innerHTML=string}function mozaika1(){for(let a=0;a<dane.length;a++){dane[a].punktyOceny=dane[a].plusyProfilowe;dane[a].punktyOceny+=(dane[a].iloscKomentarzy/77);dane[a].punktyOceny+=(dane[a].predkosc*5);}let ranking=segregowanie[3](dane);let p=[21,39];let k=[0,1];let r=[0,1,0];let m=[];let z=7000;let i=0;for (let a=0;a<44;a++){m[a]=[];for(let b=0;b<79;b++){m[a][b]=0}}while(z&&((p[0]>-1&&p[0]<44)||(p[1]>-1&&p[1]<79))){if(p[0]>-1&&p[1]>-1&&p[0]<44&&p[0]<78){if (m[p[0]][p[1]]==0){for (let a=0 ; a<20 ; a++){if(i>ranking.length-1){i=0}if (!ranking[i]){i++}else if (typeof ranking[i]!="object"){i++}else if(ranking[i].awatar=="https://i1.jbzd.com.pl/users/default.jpg"){i++}else{m[p[0]][p[1]]=ranking[i].awatar;break}}i++;}}p[0]+=k[0];p[1]+=k[1];r[2]++;if (r[2]>=r[1]){r[2]=0;k=[k[1]*-1,k[0]];if (r[0]){r[1]++}if(r[0]==0){r[0]=1}else{r[0]=0}}z--;}let s="";for (let a=0;a<44;a++){for(let b=0;b<79;b++){s+=`<img style="position:absolute; top:`+(24*a)+`px; left:`+(24*b)+`px; height:24px; width:24px;"src="`+(m[a][b]||"https://i1.jbzd.com.pl/users/default.jpg")+`"></div>`}}document.getElementById("boody").innerHTML=s}function kreski(a,b){console.log(a,b);let s="";for (let c=0 ; c<(a/b)*37 ; c++){s+="!"};return s};function mozaika2(){for(let a=0;a<dane.length;a++){dane[a].punktyOceny=dane[a].plusyProfilowe;dane[a].punktyOceny+=(dane[a].iloscKomentarzy/77);dane[a].punktyOceny+=(dane[a].predkosc*5);}let ranking=segregowanie[3](dane);let p=[25,12];let k=[0,1];let r=[0,1,0];let m=[];let z=7000;let i=0;for (let a=0;a<51;a++){m[a]=[];for(let b=0;b<25;b++){m[a][b]=0}}while(z&&((p[0]>-1&&p[0]<51)||(p[1]>-1&&p[1]<25))){if(p[0]>-1&&p[1]>-1&&p[0]<44&&p[0]<78){if (m[p[0]][p[1]]==0){for (let a=0 ; a<20 ; a++){if(i>ranking.length-1){i=0}if (!ranking[i]){i++}else if (typeof ranking[i]!="object"){i++}else if(ranking[i].awatar=="https://i1.jbzd.com.pl/users/default.jpg"){i++}else{m[p[0]][p[1]]=ranking[i].awatar;break}}i++;}}p[0]+=k[0];p[1]+=k[1];r[2]++;if (r[2]>=r[1]){r[2]=0;k=[k[1]*-1,k[0]];if (r[0]){r[1]++}if(r[0]==0){r[0]=1}else{r[0]=0}}z--;}let s="";for (let a=0;a<44;a++){for(let b=0;b<79;b++){s+=`<img style="position:absolute; top:`+(24*a)+`px; left:`+(24*b)+`px; height:24px; width:24px;"src="`+(m[a][b]||"https://i1.jbzd.com.pl/users/default.jpg")+`"></div>`}}document.getElementById("boody").innerHTML=s}function kreski(a,b){console.log(a,b);let s="";for (let c=0 ; c<(a/b)*37 ; c++){s+="!"};return s};function liczRozniceDat(data1,data2){let year=Number(data1.slice(0,4));let month=Number(data1.slice(5,7));let day=Number(data1.slice(8,10));let hours=Number(data1.slice(11,13));let minutes=Number(data1.slice(14,16));let dzien1=new Date(year, month, day, hours, minutes);year=Number(data2.slice(0,4));month=Number(data2.slice(5,7));day=Number(data2.slice(8,10));hours=Number(data2.slice(11,13));minutes=Number(data2.slice(14,16));let dzien2=new Date(year, month, day, hours, minutes);return (dzien2-dzien1)/60000}let maksPlusow=0;let makskomentarzy=0;let maksPredkosc=0;for (let a=1 ; a<dane.length ; a++){if(dane[a].plusyProfilowe>maksPlusow){maksPlusow=dane[a].plusyProfilowe}if(dane[a].iloscKomentarzy>makskomentarzy){makskomentarzy=dane[a].iloscKomentarzy}if(dane[a].iloscKomentarzy<57){dane[a].predkosc=0}else{dane[a].predkosc=Math.round((dane[a].iloscKomentarzy/((liczRozniceDat(dane[a].dataPierwszegoKomentarza,dane[a].dataOstatniegoKomentarza)||7)/1440))*10)/10};if (dane[a].predkosc>maksPredkosc){maksPredkosc=dane[a].predkosc}};let segregowanie=[];segregowanie[0]=function(d){return d};segregowanie[1]=function(d){let zwrotka=[0];for (let y=0 ; y<dane.length ; y++){let max=[-1,-1];for (let a=0 ; a<dane.length ; a++){if (!dane[a].flaga&&dane[a].iloscKomentarzy>max[1]){max[1]=dane[a].iloscKomentarzy;max[0]=a}}if (max[0]>=0){dane[max[0]].flaga=1;zwrotka[zwrotka.length]=dane[max[0]]}}return zwrotka};segregowanie[2]=function(d){let zwrotka=[0];for (let y=0 ; y<dane.length ; y++){let max=[-1,-1];for (let a=0 ; a<dane.length ; a++){if (!dane[a].flaga&&dane[a].predkosc>max[1]){max[1]=dane[a].predkosc;max[0]=a}}if (max[0]>=0){dane[max[0]].flaga=1;zwrotka[zwrotka.length]=dane[max[0]]}}return zwrotka};segregowanie[3]=function(d){let zwrotka=[0];for (let y=0 ; y<dane.length ; y++){let max=[-1,-1];for (let a=0 ; a<dane.length ; a++){if (!dane[a].flaga&&dane[a].punktyOceny>max[1]){max[1]=dane[a].punktyOceny;max[0]=a}}if (max[0]>=0){dane[max[0]].flaga=1;zwrotka[zwrotka.length]=dane[max[0]]}}return zwrotka}</script><body id="boody" style="font-family: Courier New; background-color: black; color:white; font-size: 15px; position: relative;"><div onclick="pokazRanking(0)">pokaż ramking plusów</div><div onclick="pokazRanking(1)">pokaż ramking komentarzy</div><div onclick="pokazRanking(2)">pokaż ramking prędkości pisania</div><div onclick="mozaika1()">stwórz tapetę</div><div onclick="mozaika2()">stwórz tapetę na telefon</div></body></html>'
    zapiszStringa(string,dzisiejszaData()+" ranking JBZD (HTML)")
}
function koordynacja(dane,argumentyPrzelotowe)
{
    argumentyPrzelotowe=argumentyPrzelotowe||[]
    let [aktualniePobranaStrona,maksymalnaStrona,aktualnieObrabianedane,tryb,adres,spodziewajSieDanych]=argumentyPrzelotowe
    if (!tryb)
    {
        if (typeof dane=="object")
        {
            if (aktualniePobranaStrona>3&&(opoznieniaZapytan1-granicaOpoznienZapytan1)>0){opoznieniaZapytan1-=((opoznieniaZapytan1-granicaOpoznienZapytan1)/2)}
            console.clear()
            console.log("pobieranie ogólne: "+(Math.round((aktualniePobranaStrona/dane[1])*10000)/100)+"%")
            console.log('ostatnio pobrany użytkownik miał: '+ostatniePlusy+` plusów`)
            console.log("prędkość pobierania: "+(Math.floor((3600000/(((opoznieniaZapytan1+777)/25)+((opoznieniaZapytan2+777)*3)))*100)/100)+"/h")
            return koordynacja(0,[aktualniePobranaStrona,dane[1],dane[0],2])
        }
        else
        {
            if (aktualniePobranaStrona>2)
            {
                opoznieniaZapytan1+=0.02
                granicaOpoznienZapytan1=opoznieniaZapytan1
                opoznieniaZapytan1+=0.1
            }
            console.clear()
            return pobierzStroneRankingu(aktualniePobranaStrona||1,koordynacja,[aktualniePobranaStrona||1,aktualniePobranaStrona||1,[],0])
        }
    }
    else if (tryb==1)
    {
        console.clear()
        console.log("pobieranie kolejnych użytkowników z pakietu "+(Math.round((aktualniePobranaStrona/maksymalnaStrona)*10000)/100)+"%")
        aktualniePobranaStrona++
        if (aktualniePobranaStrona>maksymalnaStrona||stopp){return zapiszPobranedane()}
        for (let a=0 ; a<przystanek.length ; a++)
        {
            if (przystanek[a]==0){zapiszPobranedane();przystanek[a]=-1}
        }
        poczekaj(pobierzStroneRankingu,[aktualniePobranaStrona,koordynacja,[aktualniePobranaStrona,maksymalnaStrona,aktualnieObrabianedane,0]],opoznieniaZapytan1)
    }
    else if (tryb==2)
    {
        if (typeof dane=="object")
        {
            if (opoznieniaZapytan2-granicaOpoznienZapytan2>0)
            {opoznieniaZapytan2-=((opoznieniaZapytan2-granicaOpoznienZapytan2)/2)}
            if (Array.isArray(adres))
            {
                if (adres[0]==1)
                {
                    aktualnieObrabianedane[adres[1]].iloscKomentarzy=dane[2]||0
                    aktualnieObrabianedane[adres[1]].maksymalnaStronaKomentarzy=dane[1]||1
                    dane[0][0]=dane[0][0]||{}
                    aktualnieObrabianedane[adres[1]].dataOstatniegoKomentarza=dane[0][0].created_at||"brak"
                }
                else if (adres[0]==2)
                {
                    dane[0][0]=dane[0][0]||{}
                    aktualnieObrabianedane[adres[1]].dataPierwszegoKomentarza=dane[0][dane[0].length-1].created_at||"brak"
                }
                else if (adres[0]==3)
                {
                    aktualnieObrabianedane[adres[1]].aktywny=dane.active||false
                    aktualnieObrabianedane[adres[1]].admin=dane.is_admin||false
                    aktualnieObrabianedane[adres[1]].moderator=dane.is_moderator||false
                    aktualnieObrabianedane[adres[1]].zbanowany=dane.banned||false
                    aktualnieObrabianedane[adres[1]].rangaMikroblogowa=dane.rank||false
                }
            }
        }
        else if (spodziewajSieDanych && typeof dane!="object")
        {
            opoznieniaZapytan2+=0.02
            granicaOpoznienZapytan2=opoznieniaZapytan2
            opoznieniaZapytan2+=0.1
        }
        for (let a=0 ; a<aktualnieObrabianedane.length ; a++)
        {
            if (aktualnieObrabianedane.length<a+1){break}
            else if ((!(aktualnieObrabianedane[a].iloscKomentarzy>=0))||!aktualnieObrabianedane[a].maksymalnaStronaKomentarzy||!aktualnieObrabianedane[a].dataOstatniegoKomentarza)
            {
                return poczekaj(pobierzKomentarze,[aktualnieObrabianedane[a].id,1,koordynacja,[aktualniePobranaStrona,maksymalnaStrona,aktualnieObrabianedane,2,[1,a],1]],opoznieniaZapytan2)
            }
            else if (!aktualnieObrabianedane[a].dataPierwszegoKomentarza)
            {
                return poczekaj(pobierzKomentarze,[aktualnieObrabianedane[a].id,aktualnieObrabianedane[a].maksymalnaStronaKomentarzy,koordynacja,[aktualniePobranaStrona,maksymalnaStrona,aktualnieObrabianedane,2,[2,a],1]],opoznieniaZapytan2)
            }
            else if (aktualnieObrabianedane[a].aktywny==undefined||aktualnieObrabianedane[a].zbanowany==undefined)
            {
                return poczekaj(pobierzDaneZmikrobloga,[aktualnieObrabianedane[a].id,koordynacja,[aktualniePobranaStrona,maksymalnaStrona,aktualnieObrabianedane,2,[3,a],1]],opoznieniaZapytan2)
            }
            else
            {
                console.log("uzupełnianie danych użytkowników "+(Math.round(((25-(aktualnieObrabianedane.length||25))/25)*10000)/100)+"%")
                for (let a=0 ; a<przystanek.length ; a++)
                {
                    if (aktualnieObrabianedane[0].points<przystanek[przystanek.length-1]){stopp=1}
                    else if (aktualnieObrabianedane[0].points<przystanek[a]){przystanek[a]=0}
                }
                dodajDoDanych(aktualnieObrabianedane.shift())
                a--
            }
        }
        if (aktualnieObrabianedane.length<1)
        {
            koordynacja(0,[aktualniePobranaStrona,maksymalnaStrona,[],1])
        }
    }
}
let pobraneDane=""
let ostatniePlusy=0
let przystanek=[50,10,3]//trzeba dopisać 1 po przecinku żeby pobrało większy ranking
let stopp=0
let opoznieniaZapytan1=0.15
let opoznieniaZapytan2=0.09
let granicaOpoznienZapytan1=0.0001
let granicaOpoznienZapytan2=0.0001
koordynacja()
