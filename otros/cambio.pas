Program Sin_nombre (Input, Output);

 //uses lista;
Type pEntero=^Integer;


function anterior(lista:tlista; x:telemento):tlista;
var p:tlista;
begin 
	if(p^.info=x AND p<>lista)
		then p^:=p^.ant;
	else if (p=lista or p^.info<>x)
		then p^:=nil;
	anterior:=p;
var
begin


 

end.
