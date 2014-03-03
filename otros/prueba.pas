Program Sin_nombre (Input, Output);
Type pEntero=^Integer;
var
p1,p2:pEntero;

begin

new(p1);
new(p2);
 p1^:=86;
 p2^:=50;
 p1:=p2;
 writeln(p1^,'',p2^);
 

end.
