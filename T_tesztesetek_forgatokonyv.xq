(: A lekérdezéssel az összes tesztesest Where feltétel szerinti listáját kapjuk meg :)
(: Az eredmény ";" elválasztott CSV. A CSV mezői a tesztforgatókönyv megfelelői.:)
(: Notepad++ -ba copy-zva a kódolást ANSII-ba kell állítani, Excelbe ezután nyitható meg.  :)
 
declare namespace con="http://eviware.com/soapui/config";

import module namespace f = 'function' at 'functions.xq';

let $db_name := 'xml_adatbazis_nev' (:A futtatás előtt be kell olvasni az adatbázist és el kell nevezni. Ide az adatbázis neve kerül:)
let $db := db:open($db_name)

let $d := ';'
let $ent := "&#10;"

for $tc in $db//con:testCase
  
  let $SoapUIProject := data($tc/../../@name)
  let $testSuite := data($tc/../@name)
  let $testCase :=  f:replace_forname(data($tc/@name))
  let $tc_desc := f:quot(f:emptyto($tc/con:description/text(), "Üres"))
  let $tc_disable := f:emptyto(data($tc/@disabled), "false")
  let $ts_disable := f:emptyto(data($tc/../@disabled), 'false')
  let $not_disabled := ($tc_disable = "false" and $ts_disable = "false")    
   
where  $not_disabled

order by $SoapUIProject, $testSuite, $testCase       
return string-join($SoapUIProject,$testSuite,$testCase,$tc_desc,
                    f:quot(
                    string-join( 
                        (for $ts in $tc//con:testStep
                          let $ts_name := data($ts/@name)
                          return  f:replace_forname($ts_name)
                        ), $ent ))
                   ,
                    f:quot(
                    string-join( 
                        (for $ts in $tc//con:testStep
                          let $ts_name := data($ts/@name)
                          for $assertion in $ts//con:assertion
                             let $assert := concat($ts_name,"==>",data($assertion/@type),":",data($assertion/@name))
                             return  f:replace_forname($assert)
                        ), $ent )))
                   , $d) 