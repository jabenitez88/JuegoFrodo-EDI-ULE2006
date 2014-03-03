Program Sin_nombre (Input, Output);

Type 
	Ptr=^tnodo;
	tnodo=record
		Info:integer;
		Sig:ptr;
		end;

Procedure sucesor(p: ptr);
begin
	while p<>nil do
		writeln(p^.info, ' esta seguido de ', p^.sig^.info);
end;

var

puntero : Ptr;

begin


sucesor(puntero);
 

end.
