Program Sin_nombre (Input, Output);

Type
	tArray = ARRAY[1..10, 1..10, 1..2] of word;
var
	rayos : tArray;

Procedure LlenaArray(var A: tArray);

Var i,j,k:integer;

Begin
	For i:=1 to 10 do
		for j:=1 to 10 do
			for k:=1 to 2 do
				begin
				A[i,j,k]:= i*j;
				writeln('A[',i,',',j,',',k,'] = ',A[i,j,k]);
				end;
End;

begin
 
 LlenaArray(rayos);
 

end.
