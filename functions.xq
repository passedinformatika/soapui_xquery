module namespace f = 'function';
(: Ha $arg nem üres, akkor $arg, különben $value :)
declare function f:if-absent ( $arg as item()* , $value as item()* )  as item()* {
    if (exists($arg))
    then $arg
    else $value
 } ;
 declare function  f:emptyto($a,$b) as xs:string {
  if (fn:empty($a)) 
  then $b
  else $a
};
 
(: $arg-ban sorban megkeresi $changeFrom elemeit és a megfelelő $changeTo-ra cseréli :)
declare function f:replace-multi( $arg as xs:string? , $changeFrom as xs:string* , $changeTo as xs:string* )  as xs:string? {
   if (count($changeFrom) > 0)
   then f:replace-multi(
          replace($arg, $changeFrom[1],
                     f:if-absent($changeTo[1],'')),
          $changeFrom[position() > 1],
          $changeTo[position() > 1])
   else $arg
 };
declare function f:replace_forname($arg as xs:string?)  as xs:string? {
   fn:replace($arg, '[^A-Za-z_0-9- öüóőúéáűíÖÜÓŐÚÉÁŰÍ]', '_')
 };


(: $a-t idézőjelbe teszi. :)
declare function f:quot($a) as xs:string {
  '"'||$a||'"'
};

(: levágja a $string első  $balrol karakterét és visszatér a maradékkal :)
declare function f:tright($string, $balrol){
  let $h := string-length($string)
  let $baltol := $balrol + 1
  let $db := $h - $balrol
  return substring($string, $baltol, $db)
};

(: $string utlsó $jobbrol karakterét adja eredményül :)
declare function f:right($string, $jobbrol){
  let $h := string-length($string)
  let $baltol := $h - $jobbrol + 1
  return substring($string, $baltol, $jobbrol)
};

