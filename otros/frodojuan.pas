rPROGRAM ElViajeDeFrodo;
{El viaje de Frodo:
Autor: Juan Antonio Valbuena Lopez
Curso: 1º de Ingenieria Informatica; Clase: B
Asignatura: Estructura de Datos y de la Informacion(EDI)}

TYPE
	tContenido=     record
			movimiento:integer;
			contenido:integer;
			end;

	tFichero=text;

	tTablero=array[1..500,1..500] of tContenido;

	tCasilla=	record
			fila:integer;
			columna:integer;
			end;

	tFrodo=		record
			VidaFrodo:integer;
			Casilla:tCasilla;
			Estado:integer;{0-->Normal;1-->Mareado}
			end;
VAR
	Fichero:tFichero;{El fichero donde se escribe el texto}
	N:integer;{numero de filas}
	M:integer;{numero de columnas}
	Tablero:tTablero;{Tablero donde se guardan los movimientos y el contenido de cada casilla}
	Frodo:tFrodo;{El personaje}
	Final:boolean;{Para ver cuando acaba el programa}
	texto:string;{Texto que se escribe en el fichero}
	DirecActual:integer;{Direccion de la casilla en la que se encuentra Frodo antes de moverse}
	ConActual:integer;{Contenido de la casilla en la que se encuentra Frodo}
	mare:integer;{contador de mareo}
	Error:integer;{para errores en tiempo de ejecucion}

{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO PEDIR-DATOS
 
Con este procedimiento pretendemos obtener los datos de las distintas casillas del tablero utilizando dos bucles for anidados para recorrer el tablero y escribir los datos del contenido y el movimiento en cada casilla.

++++++++++++++++++++
++++++++++++++++++++}

{A este procedimiento se le pasan los datos del tamaño del tablero, es decir, el numero de filas y de columnas por valor,mientras que el dato del 
tablero donde se van a almacenar los datos de contnido y movimiento se pasa por variable, ya que se va a ver modificado al escribirse los datos
en el.}

Procedure PedirDatos(N:integer;M:integer;var Tablero:tTablero);

Var
	filas:integer;
	columnas:integer;
Begin
	for filas:=1 to N do
		for columnas:=1 to M do
			begin
				write('Introduzca la direccion del movimiento en la casilla [',filas,',',columnas,']:');
				readln(Tablero[filas,columnas].movimiento);
				write('Introduzca el contenido para la casilla [',filas,',',columnas,']:');
				readln(Tablero[filas,columnas].contenido);
			end;
End;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO PEDIR-DATOS}


{+++++++++++++++++++
++++++++++++++++++++
FUNCION COMPROBACION

Con esta funcion pretendemos comprobar que las casillas [1,1] y [N,M] se encuentran vacias, es decir, no hay ningun contenido en el apartado de contenido del tablero, es decir, hay un cero en ambas casillas.
 
++++++++++++++++++++
++++++++++++++++++++}

{Esta funcion devuelve como valor un booleano, de tal manera que si las casillas mencionadas estan vacias, va a devolver el valor False, mientras
que, si al menos, una de las casillas tiene contenido, el programa da un error y no se ejecuta. Se le pasan por valor los datos del numero de
columnas y de filas, y el tablero, de tal manera que la funcion pueda leer ambas casillas sin cambiar el contenido}

Function Comprobacion(Tablero:tTablero;N:integer;M:integer):boolean;

Var
	error:boolean;
Begin
	error:=false;

	if (Tablero[1,1].contenido<>0) then
		writeln('Error:La casilla [1,1] no debe tener contenido');
	if (Tablero[N,M].contenido<>0) then
		writeln('Error:La casilla [N,M] no debe tener contenido');
	if (Tablero[1,1].contenido<>0)OR(Tablero[N,M].contenido<>0) then
		error:=true;

	comprobacion:=error;
End;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN FUNCION COMPROBACION}


{+++++++++++++++++++
++++++++++++++++++++
FUNCION OB-STRING

Con esta funcion vamos a solventar el problema que se nos da al intentar escribir en el archivo de texto un string, pasandole un entero. De esta forma transformaremos el dato entero en un dato string
 
++++++++++++++++++++
++++++++++++++++++++}

{Esta funcion devuelve un string, pasandole como dato un entero, que nos va a servir para poder escribir en el fichero de texto, ya que, lo que 
escribimos en el fichero de texto es un string y no podemos mezclar diferentes tipos}

Function OBstring(dato:integer):string;

Var
	aux:string;
Begin
	str(dato,aux);
	OBstring:=aux;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN FUNCION OB-STRING}


{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO ESCRIBIR-FICHERO

Con este procedimiento vamos a conseguir ir escribiendo poco a poco en el fichero creado los diferentes parametros de frodo:casilla en la que se encuentra, direccion de la casilla en la que se encuentra y su vida hasta el momento.
 
++++++++++++++++++++
++++++++++++++++++++}

{A este procedimiento se le pasa por variable el dato del fichero, ya que efectivamente es el que tiene que modificar para poder escribir en el, mientras
que, por otro lado, se le pasa por valor el texto que tiene que escribir, ya que es un dato que no requiere ninguna modificacion}

Procedure EscribirFichero(var Fichero:tFichero;Texto:string);

Begin
	Append(Fichero);
	writeln(Fichero,texto);
	close(Fichero);
End;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO ESCRIBIR-FICHERO}


{+++++++++++++++++++
++++++++++++++++++++
FUNCION DIRECCION

Con esta funcion vamos a hacer que pase los numeros que nos dicen el movimiento, a que movimiento es, es decir, a Norte,Sur,Este y Oeste, de tal manera que despues los podamos escribirlos en el fichero de texto. 
 
++++++++++++++++++++
++++++++++++++++++++}

{Esta funcion devuelve un string que va a ser el nombre de una de las direcciones, asi de esta manera conseguimos convertir los numeros que representan
a las direcciones en el nombre de la direccion, que nos va a servir para escribir en el fichero de texto.Tambien se le pasa un dato adicional por
valor, ya que no necesita modificacion, que es la direccion almacenada como numero entero en el tablero de juego}

Function Direccion(DirecActual:integer):string;

Begin
	if DirecActual=0 then
		Direccion:='Norte'
		else if DirecActual=1 then
			Direccion:='Sur'
			else if DirecActual=2 then
				Direccion:='Este'
				else if DirecActual=3 then
					Direccion:='Oeste';
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN FUNCION DIRECCION}


{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO DESPLAZARSE

Con este procedimiento vamos a hacer que Frodo emprenda su viaje hacian el Monte del Destino, basandose en la direccion marcada en las distintas casillas del Tablero. Hay escepciones de movimientos que son en los casos en los que frodo por causa de un movimiento indevido, se veria obligado a abandonar el tablero.En este caso Frodo gira en el sentido de las agujas del reloj para evitar dichos movimientos. Hay otro caso especial y es el de que Frodo se encuentre mareado debido a los frutos que ha tomado en alguna de las casillas. En este caso Frodo se desplaza en sentido contrario al que marque la casilla.
 
++++++++++++++++++++
++++++++++++++++++++}

{A este procedimiento solo se le pasa un dato por variable ya que es el unico que se necesita modificar, la casilla en la que se encuentra frodo:
le viene como dato de entrada la casilla actual de frodo, y tras ejecutar el movimiento, devuelve como dato de salida la nueva posicion de frodo
en funcion del movimiento que ha realizado.Para poder realizar esto se le pasan por valor datos que hay que tener en cuenta como:
dir:la direccion almacenada en el tablero en forma de numero entero;
Est:el estado de Frodo, si es normal o mareado, ya que si esta mareado el movimiento se realizara a la inversa;
Y por ultimo N y M que es el numero de filas y de columnas del tablero, que nos van a servir para ver si Frodo se sale del tablero en algun
movimiento}

Procedure Desplazarse(dir:integer;Est:integer;var frodo:tcasilla;N:integer;M:integer);

Var
	aux:integer;

	{++++++++++++++++++PROCEDIMIENTO INTERNO MOVIMIENTO++++++++++++++++++
	Con este procedimiento vamos a mover a Frodo a traves del Tablero.}
	
	{A este procedimiento interno, al igual que al externo, se le pasa el valor de la casilla donde se encuentra Frodo por variable para que
	sea modificada, de tal manera que Frodo se mueva, y por valor se le pasan el dato que contiene la direccion en el tablero (dir) y el numero
	de filas y de columnas del tablero, para comprobar que Frodo no se sale del tablero, y en tal caso, devolverle a el moviendolo en el 
	sentido de las agujas del reloj} 
	
	procedure Movimiento(dir:integer;var frodo:tcasilla;N:integer;M:integer);
	
	begin
	
		case dir of
				0 : {NORTE}
					begin
					frodo.fila:=frodo.fila-1;
					if (frodo.fila<1) then{Si no puede ir al norte...al este}
						begin
						frodo.fila:=frodo.fila+1;
						frodo.columna:=frodo.columna+1; 
						if (frodo.columna>M) then{Si no puede ir al este...al sur}
							begin
							frodo.fila:=frodo.fila+1;
							frodo.columna:=frodo.columna-1;
							end;
						end;
					end;
				1 : {SUR}
					begin;
					frodo.fila:=frodo.fila+1;
					if (frodo.fila>N) then{si no puede ir al sur...al oeste}
						begin
						frodo.fila:=frodo.fila-1;
						frodo.columna:=frodo.columna-1;
						if (frodo.columna<1) then{si no puede ir al oeste...al norte}
							begin
							frodo.fila:=frodo.fila-1;
							frodo.columna:=frodo.columna+1;
							end;
						end;
					end;
				2 : {ESTE}
					begin
					frodo.columna:=frodo.columna+1;
					if (frodo.columna>M) then{si no puede ir al este...al sur}
						begin
						frodo.columna:=frodo.columna-1;
						frodo.fila:=frodo.fila+1;
						end;{Aqui no se incluye la segunda opcion ya que equivaldria a la esquina inferior derecha, y como es el final, nunca se da el caso}
					end;
				3 : {OESTE}
					begin
					frodo.columna:=frodo.columna-1;
					if (frodo.columna<1) then{si no puede ir al oeste...al norte}
						begin
						frodo.columna:=frodo.columna+1;
						frodo.fila:=frodo.fila-1;
						if (frodo.fila<1) then{si no puede ir al norte...al este}
							begin
							frodo.fila:=frodo.fila+1;
							frodo.columna:=frodo.columna+1;
							end;
						end;
					end;
		end;{Fin del case}
	end;{FINAL DEL PROCEDIMIENTO MOVIMIENTO ANIDADO AL PROCEDIMIENTO DESPLAZARSE}
Begin
	aux:=0;
	if (Est=0) then{En el caso de que no este mareado hacemos el movimiento normal...}
		Movimiento(dir,frodo,N,M)
	else{...Pero si esta mareado, hacemos el movimiento inverso cambiando la direccion de la casilla}
		begin
			case dir of
				0 : {Movimiento Norte cambiado a Sur}
					begin
					aux:=1;
					Movimiento(aux,frodo,N,M);
					end;
				1 : {Movimiento Sur cambiando a Norte}
					begin
					aux:=0;
					Movimiento(aux,frodo,N,M);
					end;
				2 : {Movimiento Este cambiado a Oeste}
					begin
					aux:=3;
					Movimiento(aux,frodo,N,M);
					end;
				3 : {Movimiento Oeste cambiado a Este}
					begin
					aux:=2;
					Movimiento(aux,frodo,N,M);
					end;
			end;{Final del case}
		end;{Final del if-else}
End;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO DESPLAZARSE}


{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO CALCULAR-VIDA

Con este procedimiento vamos a calcular la vida de frodo, dependiendo de los objetos con los que se vaya encontrando por el camino:en el caso del pan se le sumara dos de vida, en el caso de un orco se le restara 3 puntos de vida, y por ultimo el caso especial de que si esta mareado y se encuentra con un orco, Frodo muere automaticamente.
 
++++++++++++++++++++
++++++++++++++++++++}

{A este procemiento, como su funcion es calcular la nueva vida de Frodo cada vez que se mueveo que encuentra un objeto en la casilla, se le pasa por
variable la vida de Frodo(VidaFrodo), y por valor le pasamos datos que va a necesitar para calcular dicha vida, como son el contenido de la casilla
(contenido)y el estado en el que se encuentra(Est), ya que dependiendo de si esta o no esta mareado, la forma de restarle o sumarle vida varia}

Procedure CalcularVida(contenido:integer;var VidaFrodo:integer;Est:integer);

Begin
	case Est of

		0 : {Frodo no esta mareado}
			begin
				if (contenido=0) then
					VidaFrodo:=VidaFrodo-1
					else if (contenido=1) then
						VidaFrodo:=VidaFrodo+2
						else if (contenido=3) then
							VidaFrodo:=VidaFrodo-3;
			end;
		1 : {Frodo esta mareado}
			begin
				if (contenido=0) then
					VidaFrodo:=VidaFrodo-2
					else if (contenido=1) then
						VidaFrodo:=VidaFrodo
						else if (contenido=3) then
							VidaFrodo:=0;
			end;
	end;
	{Puede darse el caso de que la vida acabe siendo negativa, asi que para evitar ese caso, 	 si la vida fuese negativa la igualaremos a 0, ya que Frodo esta muerto igualmente y nos 	ahorramos de esta manera un caso que nos podria causar algun problema}
	if (VidaFrodo<0) then
		VidaFrodo:=0;
	
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO CALCULAR-VIDA}


{+++++++++++++++++++
++++++++++++++++++++
FUNCTION FIN

Con este procedimiento vamos a determinar la causa por la que el juego se termina, ya sea por las diferentes causas en las que Frodo muere, o por que Frodo ha conseguido llegar a su destino. 
 
++++++++++++++++++++
++++++++++++++++++++}

{Esta funcion devuelve un dato booleano, que nos va a servir para determinar el final del juego. Si es true, el juego llega a su fin, debido a uno
de los posibles finales que se analizan en dicha funcion, mientras que si es false, quiere decir que el juego no ha terminado y por lo tanto
debe continuar. Para poder determinar si se ha acabado el juego o no, le pasamos otros datos a la funcion por valor, como son:
ConActual: el contenido de la casilla en la que se encuentra Frodo, ya que si esta mareado, en la casilla hay un orco, y su vida es cero, quiere decir
que el orco ha matado a Frodo;
Casilla:la casilla en la que se encuentra Frodo en este momento;
N y M son el numero de filas y de columnas;
VidaFrodo: es la vida de Frodo, ya que si es cero, Frodo ha muerto y tenemos que decir la causa;
Est:el estado de Frodo,mareado o no.}

Function Fin(ConActual:integer;Casilla:tcasilla;N:integer;M:integer;VidaFrodo:integer;Est:integer):boolean;

Var
	final:boolean;
Begin
	final:=False;
	if (VidaFrodo=0)AND(Est=1)AND(ConActual=3) then
		begin
		writeln('Frodo ha muerto porque un orco le ha matado');
		final:=True;
		end
		else if (VidaFrodo=0) then
			begin
			writeln('Frodo ha muerto porque se le ha agotado la vida');
			final:=true;
			end;
	if (casilla.fila=N)AND(casilla.columna=M) then
		begin
		writeln('Frodo ha llegado a su destino y ha conseguido destruir el anillo');
		final:=true;
		end;
	Fin:=final;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN FUNCION FIN}


{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO MAREADO

Con este procedimiento cambiamos el estado de Frodo de mareado a no mareado en el caso de que se coma los frutos de Mordor.
 
++++++++++++++++++++
++++++++++++++++++++}

{A este procedimiento se le pasan por variable tres datos:
mare:que es el contador de estado mareado, para que Frodo al encontrarse con los frutos,este mareado durante 5 turnos, y en caso de que se
vuelva a encontrar con los frutos se sumen otros 5 turnos a dicho contador;
VidaFrodo: hay que tenerla en cuenta, ya que en el caso de que se encuentre con frutos, en la funcion CalcularVida no aparece la opcion de frutos,
entonces hay que quitarle aqui la vida, un solo punto si es la primera vez que se encuentra con los frutos, pero si es la segunda vez que se los
encuentra mientras esta mareado, se la quitan dos puntos de Vida ya que al estar mareado cada movimiento resta dos puntos de vida;
Est: nos devuelve el estado de Frodo, si come frutos, devuelve el estado mareado de frodo, y si no los come, devuelve el estado de que frodo
no esta mareado}

Procedure Mareado(var mare:integer;var VidaFrodo:integer;var Est:integer);

Begin
	if (mare<>0)then{mare es el contador de mareado, si mare es distinto de cero entonces se le resta un punto en cada turno}
		mare:=mare-1;
	if (ConActual=2) then
		begin
		VidaFrodo:=VidaFrodo-1;{hay que quitarle un punto de vida debido al movimiento que ha realizado}
		mare:=mare+5;{Le sumamos 5 puntos al contador de mareo si se encuentra con los frutos}
		if (mare>5) then
			VidaFrodo:=VidaFrodo-1;{En el caso de que se encuentre por segunda vez con un fruto, se le resta dos de vida del anterior fruto por el movimiento}
		end;
	if (mare<>0) then
		Est:=1{activamos el estado mareado de Frodo}
		else Est:=0;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO MAREADO}


{+++++++++++++++++++
++++++++++++++++++++
PROCEDIMIENTO ERRORES

Este procedimiento sirve para la deteccion de errores en tiempo de ejecucion a la hora de trabajar con ficheros.
 
++++++++++++++++++++
++++++++++++++++++++}

{A este procedimiento se le pasa por valor un numero entero, que si es cero es que no se ha cometido ningun error en tiempo de ejecucion, y por lo
tanto el procedimiento no escribe por pantalla ninguna error, mientrasque si el numero es distinto d cero es que se ha cometido un error, y lo que
hace el procedimiento es mostrar por pantalla a que error corresponde dicho numero}

Procedure Errores(Error:integer);

Begin

	case error of
			{Errores del Dos}
			2 : writeln('Archivo no encontrado');
			3 : writeln('Path no encontrado');
			4 : writeln('Demasiados archivos abiertos');
			5 : writeln('Acceso denegado');
			6 : writeln('Variable de manipulacion de archivo invalida');
			12 : writeln('Modo de acceso al archivo invalido');
			15 : writeln('Numero de disco invalido');
			16 : writeln('No se puede borrar el actual directorio');
			17 : writeln('No puede renombrar al otro lado de los volumenes');
			{Errores de entrada y salida}
			100 : writeln('Error cuando se intentaba leer desde el disco');
			101 : writeln('Error cuando se intentaba escribir en el disco');
			102 : writeln('Archivo no asignado o adjuntado');
			103 : writeln('Archivo no abierto');
			104 : writeln('Archivo no abierto para entrada');
			105 : writeln('Archivo no abierto para salida de datos');
			106 : writeln('Numero invalido');
			{Errores fatales}
			150 : writeln('Disco esta protegido para escritura');
			151 : writeln('Dispositivo desconocido');
			152 : writeln('Disco no listo');
			153 : writeln('Comando desconocido');
			154 : writeln('Chequeo de CRC fallado');
			155 : writeln('Disco especificado invalido');
			156 : writeln('Fallo al buscar en el disco');
			157 : writeln('Tipo invalido');
			158 : writeln('Sector no encontrado');
			159 : writeln('Impresora sin papel');
			160 : writeln('Error cuando se intentaba escribir en el dispositivo');
			161 : writeln('Error cuando se intentaba leer desde el dispositivo');
			162 : writeln('Fallo del Hardware');
		end;
End;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FIN PROCEDIMIENTO ERRORES}	

{Inicializacion del programa}
BEGIN


{Inicializacion de las variables de Frodo}

	Frodo.Casilla.fila:=1;
	Frodo.Casilla.columna:=1;
	Frodo.Estado:=0;
	mare:=0;


{Creacion del Fichero de texto donde se va a escribir el recorrido de Frodo}

	Assign(Fichero,'Fichero.txt');
	{$I-}Rewrite(Fichero){$I+};
	Error:=Ioresult;
	if (error<>0) then
	{El siguiente procedimiento sirve para detectar un error en tiempo de ejecucion}
		Errores(Error);
	{Cierre del fichero abierto}
	Close(Fichero);


{Peticion de los datos principales del programa}

	write('Introduzca el numero de filas:');
	readln(N);
	write('Introduzca el numero de columnas:');
	readln(M);
	write('Introduzca la vida inicial de Frodo, siendo el maximo N*M:');
	readln(Frodo.VidaFrodo);


{Llamada al procedimiento pedir datos para obtener las direcciones y el contenido de las casillas}

	PedirDatos(N,M,Tablero);


{Llamada a la funcion comprobacion para comprobar que las casillas [1,1] y [N,M] se encuentran vacias, y a continuacion poder empezar el juego}

	
	if comprobacion(Tablero,N,M)<>true then
		
		begin
			Final:=false;


			{Vamos a escribir inicialmente cual es la posiscion de 	frodo,la 				direccion que marca la casilla en la que se encuentra y la vida que 				tiene, dentro del fichero de texto creado.Para ello llamaremos a la 				funcion EscribirFichero.Para ello le pasaremos a la funcion una variable 				string denotada como 'texto' que le pasara a la funcion directamente el 				texto que debe escribir, de esta manera nos facilitamos los posibles 				errores.Este caso solo sirve para la primera casilla, por lo que el dato 				de la posicion ya lo sabemos}

			DirecActual:=Tablero[1,1].movimiento;

			{Debido a que la vida de frodo es un dato entero y necesito un string, 				ese dato lo vamos a someter a una transformacion para que se combierta en 				string a trave de una funcion}

			texto:='[1,1] - ' + Direccion(DirecActual) + ' - ' + OBstring(Frodo.VidaFrodo) + '';

			EscribirFichero(Fichero,Texto);
			
			{Puede que Frodo nada mas empezar empiece ya con 0 de vida, luego en este 				caso el juego termina aqui ya que Frodo no tiene vida suficiente como 				para empezar el recorrido}

		if (Frodo.VidaFrodo)=0 then 
			writeln('Frodo ha muerto porque la vida inicial es 0 y no ha podido emprender su viaje')
			else
			while Final<>true do


				begin


					{Ahora vamos a comenzar moviendo a Frodo, para ello 						haremos la llamada al procedimiento Desplazarse}


					Desplazarse(DirecActual,Frodo.Estado,Frodo.casilla,N,M);

					{Ahora que ya hemos conseguido que Frodo se desplace, 						vamos a observar el contenido de la casilla en la que se 						encuentra, y a quitarle o darle vida en consecuencia de 					lo que se encuentre. Hay un caso especial que son las 						casillas [1,1] y [N,M], que no quitan vida}


					ConActual:=Tablero[Frodo.casilla.fila,Frodo.casilla.columna].contenido;

					{A continuacion comprobaremos si el contenido de la 						casilla son los frutos de Mordor, y en tal caso,Frodo se 						mareara con todo lo que eso conlleva.Para realizar esto 						acudiremos al procedimiento Mareado}
					
					Mareado(mare,Frodo.VidaFrodo,Frodo.Estado);
					
					{Ahora nos ocuparemos de la vida de Frodo en cuestion al 						contenido de la casilla en la que se encuentre}
					
					if ((Frodo.casilla.fila=1)AND(Frodo.casilla.columna=1))OR((Frodo.casilla.fila=N)AND(Frodo.casilla.columna=M))then
					Frodo.VidaFrodo:=Frodo.Vidafrodo{En caso de que Frodo se encuentre en la primera o en la ultima casilla no se le resta vida}
					else CalcularVida(ConActual,Frodo.VidaFrodo,Frodo.Estado);

					{Ahora hay que calcular un nuevo texto para escribir en 					el fichero}
					
					DirecActual:=Tablero[Frodo.casilla.fila,Frodo.casilla.columna].movimiento;
					Texto:='['+OBstring(Frodo.casilla.fila)+','+OBstring(Frodo.casilla.columna)+'] - '+Direccion(DirecActual)+' - '+OBstring(Frodo.VidaFrodo)+'';
					EscribirFichero(Fichero,Texto);

					
					{Ahora vamos a hayar la causa de que el juego se acabe, a 						traves de la funcion Fin, de tal manera que si es 						verdadera se saldra del while y ya no se ejecutara}

					Final:=Fin(ConActual,Frodo.casilla,N,M,Frodo.VidaFrodo,Frodo.Estado);

					{Ahora para finalizar, vaciaremos el contenido de la 						casilla en la que se encuentra, ya que, ya hemos 						utilizado dicho dato para todo lo que necesitabamos}


					Tablero[Frodo.casilla.fila,Frodo.casilla.columna].contenido:=0;


				end;{Fin del while}
		end;{Fin del if}



END.{Final del programa}
