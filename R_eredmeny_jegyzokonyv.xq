(: A jegyzőkönyvet lehet előállítani a futás után keletkező xUnit riport formátumú XML-ekből :)
(: Az eredmény ";" elválasztott CSV. Notepad++ -ba copy-zva a kódolást ANSII-ba kell állítani, Excelbe ezután nyitható meg.  :)

import module namespace f = 'function' at 'functions.xq';

let $db_name := 'b1' (:Az eredmény mappa teljes tartalmát a b1 nevű adatbázisba kell tölteni:)
let $db := db:open($db_name)

let $d := ';'
let $ent := "&#10;"

for $tc in $db//testcase
  
  let $tc_name := f:replace_forname($tc/@name)
  let $tc_time := $tc/@time
  let $ts_name0 := $tc/../@name
  let $ts_name := tokenize($ts_name0,"\.")[2]
  let $tc_fail := f:emptyto($tc/failure/text(), "OK")
  let $tc_isfail := ($tc_fail != "OK")
  let $passed := if  ($tc_fail != "OK") then "Failed" else "Passed"
  
order by $ts_name,$tc_name
return string-join(($passed,$ts_name,$tc_name,$tc_time), $d)