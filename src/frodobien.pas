

// :: EL VIAJE DE FRODO ::  Enero 2007
// Jose Alberto Benítez Andrades

PROGRAM EL_VIAJE_DE_FRODO;

CONST
	MAX    = 500;
{ Declaro como constantes los objetos y movimientos, para más adelante poder usar las constantes
declaradas en lugar de los strings, evitando el tener que escribir las comillas }
	NADA   = 'NADA';
	PAN    = 'PAN';
	FRUTOS = 'FRUTOS';
	ORCO   = 'ORCO';

	NORTE  = 'NORTE';
	SUR    = 'SUR';
	ESTE   = 'ESTE';
	OESTE  = 'OESTE';


TYPE

        tMovimiento = word;
        tObjeto     = word;

	tEnergia     = integer;
	tEstado      = (NORMAL, MAREADO);
	tTiempoMareo = word;

	tCasilla = record
                        movimiento : tMovimiento;
                        objeto     : tObjeto;
                   end;

	// Casilla donde se encuentra nuestro Frodo
	tCasillaFrodo = record
				fila   : word;
				columna: word;
			 end;

	// Datos que afectan a Frodo
	tPersonaje = record
			energia      : tEnergia;
			estado       : tEstado;
			tiempoMareo  : tTiempoMareo;
			casilla      : tCasillaFrodo;
		     end;
	


	tFicheroLog = text;
	tTablero = array [1..MAX, 1..MAX] of tCasilla;


VAR
	filas	   : word;
	columnas   : word;
	tablero	   : tTablero;
	frodo      : tPersonaje;       { El pequeño Frodo }
	mensaje    : string;
	ficheroLog : tFicheroLog;

	movimientoActual : tMovimiento;
	objetoActual     : tObjeto;
	estadoActual     : tEstado;
	casillaAnt	 : tCasillaFrodo;
        finPartida       : boolean;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ La función verMovimiento nos ayudará a ver mejor en las siguientes funciones los movimientos, 
pudiéndolos llamar por su propio nombre en lugar de ver únicamente números, por ejemplo si tenemos
que decir que frodo cuando vaya al norte, reste uno a la fila, lo escribiremos de la siguiente
manera:

if (verMovimiento(mv) = NORTE)
	then cf.fila := cf.fila -1

Ahorrándonos el tener que pensar qué dirección era el 0,1,2 o 3 :

if (mv = 0) 
	then cf.fila := cf.fila -1

Esta función recibe un dato de tipo tMovimiento ( word ) y devuelve un string.
}

FUNCTION verMovimiento(mov:tMovimiento):string;
Var
	nombreMov:string;
Begin
	case mov of
		0 : nombreMov:= 'NORTE';
		1 : nombreMov:= 'SUR';
		2 : nombreMov:= 'ESTE';
		3 : nombreMov:= 'OESTE';
	end;

	verMovimiento:= nombreMov;
End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ La función verObjeto al igual que verMovimiento, nos será de utilidad para funciones posteriores,
por ejemplo si tenemos que decir que frodo pierda 1 punto de energía cuando no hay nada en el tablero,
podremos hacer un if que sea de la siguiente manera:

if (verObjeto(obj) = NADA)
	then energia := energia -1

Ahorrándonos el tener que pensar qué objeto es el 0,1...

if (obj = 0) 
	then energia := energia -1

Esta función recibe un dato de tipo tObjeto ( word ) y devuelve un string.
}

FUNCTION verObjeto(obj:tObjeto):string;
Var
	nombreObj:string;
Begin
	case obj of
		0 : nombreObj:= 'NADA';
		1 : nombreObj:= 'PAN';
		2 : nombreObj:= 'FRUTOS';
		3 : nombreObj:= 'ORCO';
	end;

	verObjeto:= nombreObj;
End;

///////////////////////////////////////////////////////
//////////////////////////////////////////////////////

{ Este PROCEDURE recibirá por valor un dato de tipo tObjeto ( word ) y por variable un dato de 
tipo tTiempoMareo (un word) la cual modificará dependiendo del objeto con el que se encuentre 
frodo en la casilla, así, si frodo encuentra frutos  el tiempo de mareo será igual a 5 
( 5 movimientos mareado ) y si el tiempo es mayor que 0 vaya restándose, así acabará su mareo 
en la quinta jugada y si encuentra frutos por en medio, 5 al tiempo que le quedaba de mareo }

PROCEDURE cambiaTiempoMareo(var t: tTiempoMareo; obj: tObjeto);

Begin
	if (t>0)
		then t := t - 1;    // Si el tiempo es mayor que 0, se resta una unidad en cada movimiento
	if (verObjeto(obj)='FRUTOS')
		then t := t + 5     // Si el objeto es un FRUTO ... aumentamos el tiempo de mareo
End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ La función calcularEstado apoyándose en el procedure anterior, determinará si frodo está mareado
o está normal, le llega por valor la variable t de tipo tTiempoMareo (word) por la cual, si su valor
es mayor a 0, tomará el estado como valor "MAREADO" o por el contrario si no es mayor que 0, 
tomará el valor de NORMAL

Devuelve un dato de tipo tEstado. }

FUNCTION calcularEstado(t : tTiempoMareo):tEstado;

Var 
	estado: tEstado;
Begin
	if (t>0)
		then estado := MAREADO
		else estado := NORMAL;

		calcularEstado := estado;
end;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Con borrarObjeto hacemos que frodo al pasar por cada casilla, exista el objeto que exista
se borre, quedando la casilla con el objeto NADA

Para que funcione se le debe enviar como parámetros el tablero (por variable, ya que se modificará) 
las filas ( word ) y las columnas ( word ) , estas 2 últimas por valor.}

PROCEDURE borrarObjeto (var tab: tTablero; fil : word; col : word);

Begin
	tab[fil,col].objeto := 0;

end;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Simple procedure que pide insertar los datos, recibe por variable las filas (N de tipo word)
las columnas(M de tipo word) y la energía (e de tipo integer) }

PROCEDURE pedirDatosPrimarios(var N:word; var M:word;var e:tEnergia);
Begin
	repeat
        	write('Introduzca el numero de filas: ');
        	readln(N);
	until(N<=500) and (N>0);

	repeat
        	write('Introduzca el numero de columnas: ');
        	readln(M);
	until(M<=500) and (M>0);

        repeat
        	write('Introduzca la energía inicial de frodo: (MENOR A ', N*M, ')');
        	readln(e);
        until(e<=N*M);
End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Este procedure es el que pide al usuario insertar los datos de cada casilla, en los que
se necesita saber las filas y columnas que hay (N y M) y modificar el tablero de tipo
tTablero que contendrá movimiento y objeto

Recibe N de tipo word y M de tipo word por valor y el tablero de tipo tTablero por 
variable. }

PROCEDURE pedirContenidoCasillas(N:word; M:word; var tablero:tTablero);

Var
        i:word;
        j:word;
Begin	
	writeln('MOVIMIENTOS => 0 - NORTE | 1 - SUR | 2 - ESTE | 3 - OESTE');
	writeln('OBJETOS => 0 - NADA | 1 - PAN | 2 - FRUTOS | 3 - ORCO');

        for i:=1 to N do
        	for j:=1 to M do
                        begin
                        	write('Introduzca la direccion para la casilla [',i,',',j,']: ');
                        	readln(tablero[i,j].movimiento);
                        	write('Introduzca el objeto [',i,',',j,']: ');
                        	readln(tablero[i,j].objeto);
                        end;

End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Este procedure trata las excepciones en los movimientos de frodo, es decir, la fila 1, N y columnas
1 y M y todas sus posibles variantes.

Como parámetros tiene las columnas y filas de tCasillaFrodo (cf) el movimiento, que pasa por variable 
ya que se modifica, el número de filas, el número de columnas (N y M de tipo word pasados por valor) y 
el estado de frodo ( de tipo tEstado pasado por valor), ya que el movimiento no se ejecuta de la misma 
manera. }

PROCEDURE cambiaMovSiEsBorde(cf: tCasillaFrodo; var mov: string; N: word; M: word; est : tEstado);

Begin
	if (est = NORMAL) then begin
				case mov[1] of

				'N' :  // Movimiento al NORTE ...

					if (cf.fila = 1)   // ... ¡ en la PRIMERA FILA !
						then begin
							if (cf.columna = M)
								then mov:= 'SUR'      // Casilla [1, MAX]
								else mov:= 'ESTE';    // Casillas [1, 1]-[1,MAX-1]
							end;

				'S' : // Movimiento al SUR ...

					if (cf.fila = N) // ... ¡ en la ÚLTIMA FILA !
						then begin
							if (cf.columna = 1)
								then mov:= 'NORTE'    // Casilla [MAX, 1]
								else mov:= 'OESTE';   // Casillas [MAX, 2]-[MAX, MAX]
							end;

				'E' : // Movimiento al ESTE ...

					if (cf.columna = M) // ... ¡ en la ÚLTIMA COLUMNA !
						then begin
							if (cf.fila = N)
								then mov:= 'OESTE'   // Casilla [MAX, MAX]
								else mov:= 'SUR';    // Casillas [1, MAX]-[MAX-1, MAX-1]
							end;

				'O' : // Movimiento al OESTE ...

					if (cf.columna = 1) // ... ¡ en la ÚLTIMA COLUMNA !
						then begin
							if (cf.fila = 1)
								then mov:= 'ESTE'    // Casilla [1, 1]
								else mov:= 'NORTE';  // Casillas [2, 1]-[MAX-1, 1]
							end;
				end;
	end;

	if (est = MAREADO) then begin
			case mov[1] of

				'S' :  // Movimiento al SUR

					if (cf.fila = 1)   // ... ¡ en la PRIMERA FILA !
						then begin
							if (cf.columna = M)
								then mov:= 'NORTE'      // Casilla [1, MAX]
								else mov:= 'OESTE';    // Casillas [1, 1]-[1,MAX-1]
							end;

				'N' : // Movimiento al NORTE ...

					if (cf.fila = N) // ... ¡ en la ÚLTIMA FILA !
						then begin
							if (cf.columna = 1)
								then mov:= 'SUR'    // Casilla [MAX, 1]
								else mov:= 'ESTE';   // Casillas [MAX, 2]-[MAX, MAX]
							end;

				'O' : // Movimiento al ESTE ...

					if (cf.columna = M) // ... ¡ en la ÚLTIMA COLUMNA !
						then begin
							if (cf.fila = N)
								then mov:= 'ESTE'   // Casilla [MAX, MAX]
								else mov:= 'NORTE';    // Casillas [1, MAX]-[MAX-1, MAX-1]
							end;

				'E' : // Movimiento al OESTE ...

					if (cf.columna = 1) // ... ¡ en la ÚLTIMA COLUMNA !
						then begin
							if (cf.fila = 1)
								then mov:= 'OESTE'    // Casilla [1, 1]
								else mov:= 'SUR';  // Casillas [2, 1]-[MAX-1, 1]
							end;
				end;
	end;

End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Con moverAFrodo moveremos a Frodo, dependiendo del lugar que nos indique la casilla ( Norte,
Sur, Este u Oeste), el estado de frodo (Normal o Mareado) y las filas y columnas que haya para
tratar el movimiento cuando está en los casos especiales contados en el anterior procedure. 

Los parámetros que recibe por valor son mv de tipo tMovimiento ( word ), est (tEstado) N ( word )
M ( word ) y por variable cf de tipo tCasillaFrodo. }

PROCEDURE moverAFrodo(mv: tMovimiento; est: tEstado ; var cf: tCasillaFrodo; N : word; M: word);

Var
	mov : string;
Begin
	mov:= VerMovimiento(mv);  // Tomamos la cadena entera ...

	// Vemos si es una casilla "especial" por estar en los bordes, donde Frodo se mueve
	// según el sentido horario de las casillas del reloj ...

	cambiaMovSiEsBorde(cf, mov, N, M, est);

	if (est = NORMAL)
		then begin
			case mov[1] of   // ... pero sólo usamos la primera letra para el CASE

				'N' : cf.fila:= cf.fila - 1;       // NORTE = FILA ANTERIOR
				'S' : cf.fila:= cf.fila + 1;       // SUR   = FILA SIGUIENTE
				'E' : cf.columna:= cf.columna + 1; // ESTE  = COLUMNA SIGUIENTE
				'O' : cf.columna:= cf.columna - 1; // OESTE = COLUMNA ANTERIOR
			end;
		     end;

	if (est = MAREADO) 
		then begin
			case mov[1] of

				'N' : cf.fila:= cf.fila + 1;       // NORTE =  SUR NORMAL
				'S' : cf.fila:= cf.fila - 1;       // SUR   =  NORTE NORMAL
				'E' : cf.columna:= cf.columna - 1; // ESTE  =  OESTE NORMAL
				'O' : cf.columna:= cf.columna + 1; // OESTE =  ESTE NORMAL

			end;
		     end;
End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Este procedure calculará la energía de Frodo dependiendo del objeto que se encuentre en la casilla,
el estado en el que esté y la energía que tenga, que será pasada por variable ya que se modificará
de forma constante en cada movimiento

Recibe como parámetros por valor ob ( tObjeto, word ) est ( tEstado ) y por variable energia ( tEnergia ,
integer ). }

PROCEDURE calcularNivelEnergia(ob:tObjeto; est:tEstado; var energia:tEnergia);

Var
	obj    :string;
Begin
	obj:= VerObjeto(ob);
	if (est = NORMAL)
		then begin
			if (obj = NADA)
				then energia:= energia - 1
				else if (obj = PAN)
					then energia:= energia + 2
					else if(obj = ORCO)
						then energia:= energia - 3
						else if(obj = FRUTOS)
							then energia:= energia;
		     end;

	if (est = MAREADO)
		then begin
			if (obj = NADA)
				then energia:= energia - 2
				else if (obj = PAN)
					then energia:= energia + 2
					else if(obj = ORCO)
						then energia:= 0
						else if(obj = FRUTOS)
							then energia:= energia;
		     end;

	if (energia<0) 
		then energia:= 0;

End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

Procedure calcError(error:integer);

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

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Simple procedure que nos creará el log del juego, si no existe crea un recorrido.txt y si ya
existía, lo sobreescribe dejando uno en blanco en su lugar 

Recibe como parámetro por variable un log de tipo tFicheroLog ( text ). }

PROCEDURE crearLog(var log: tFicheroLog);

Var
	error	: integer;

Begin
	Assign(log,'log.txt');
	{$I-}Rewrite(log){$I+};
	error:=Ioresult;
	if (error<>0) then
	{El siguiente procedimiento sirve para detectar un error en tiempo de ejecucion}
		calcError(error);
	{Cierre del fichero abierto}
	Close(log);
End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Después de haber creado el log con el anterior procedure, este escribeLog abrirá el recorrido.txt
y añadirá una línea que contiene un mensaje que declaramos en el cuerpo del programa, el mensaje 
le llega por string y es de la siguiente forma :
* MENSAJE --> [fila, columna] - DIRECCIÓN - ENERGÍA ACUMULADA 

Posée como parámetros msj de tipo string que llega por valor, y log de tipo tFicheroLog que es pasado
por variable, ya que modifica el log }

PROCEDURE escribeLog(var log: tFicheroLog; msj: string);

Begin
        Assign(log,'log.txt'); //No creo que lo tengas que asignar otra vez, no?
	Append(log);
	writeln(log, msj);
        close(log);
end;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ esFinDePartida será nuestro limitador de juego, cuando ocurran uno de los tres casos escritos
el juego llegará a su fin, hay 3 casos fundamentales:

+ El primero es que frodo se quedé sin energía por causas naturales ( es decir, que no sea 
porque se haya encontrado con un orco mientras estaba mareado )

+ El segundo caso es encontrarse a un orco mareado, con lo que morirá de forma inmediata

+ Y el tercer caso es que llegue a Mordor vivo y consigua destruír el anillo

En estos tres casos la función devolverá un booleano TRUE que hará que finalice la partida
en el repeat principal del cuerpo del programa.

Recibe como parámetros e ( tEnergia, integer ), est ( tEstado ), ob ( tObjeto, word ), cf ( tCasillaFrodo ),
N ( word ) y M ( word ), devuelve un booleano. }

FUNCTION  esFinDePartida(e : tEnergia; est: tEstado; ob: tObjeto; cf: tCasillaFrodo; N: word; M: word):boolean;

Var
	final : boolean;
Begin
        final := FALSE;

	if (est = MAREADO) AND (verObjeto(ob) = ORCO)
		then begin
                        writeln('Frodo ha muerto a manos de un orco debido a su mareo');
		        final := TRUE;
                end

	else if (e = 0)
		then begin
                        writeln('Frodo ha muerto por pérdida de energía');
	                final := TRUE;
                end

        else if (cf.fila = N) AND (cf.columna = M)
		then begin
                        writeln('Frodo ha llegado a Mordor y ha destruído el anillo');
	                final := TRUE;
                end;



        esFinDePartida := final;

End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

{ Esta función nos sirve para poder hacer que las filas y columnas se devuelvan como string
en lugar de ser word, esto nos servirá para poder crear el mensaje que meteremos en el 
recorrido.txt 

Recibe un entero de tipo word y devuelve un string. }

FUNCTION converNum(entero : word):string;

Var
	caracter: string;
Begin
	str(entero, caracter);

	converNum := caracter;


End;

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

BEGIN

// Se inicializa

// Se crea el fichero log
crearLog(ficheroLog);

// Se piden los datos primarios : Filas/Columnas del tablero , Energía inicial Frodo
pedirDatosPrimarios(filas, columnas, frodo.energia);

// Ahora el contenido de las casillas
pedirContenidoCasillas(filas, columnas, tablero);

// Si las posiciones [1, 1] y [N, M] no están vacías, el programa muestra un error

if ((verObjeto(tablero[1,1].objeto) <> 'NADA') or (verObjeto(tablero[filas,columnas].objeto) <> 'NADA'))
	then begin
		writeln('ERROR : Las casillas [1, 1] y [',filas,', ',columnas,'] deben estar vacías de objetos');
		escribeLog(ficheroLog, 'ERROR'); // Esto es para probar ...
	     end
	else begin

		// Inicializamos los datos con los que Frodo comienza el recorrido
		frodo.casilla.fila    := 1;
		frodo.casilla.columna := 1;
		estadoActual := NORMAL;
                finPartida := FALSE;
		frodo.tiempoMareo := 0;
		// Frodo comienza el recorrido ...

		
		repeat
			
			// Movimiento y objeto de la casilla actual de Frodo
			movimientoActual := tablero[frodo.casilla.fila, frodo.casilla.columna].movimiento;
			objetoActual := tablero[frodo.casilla.fila, frodo.casilla.columna].objeto;
			cambiaTiempoMareo(frodo.tiempoMareo, objetoActual);
			estadoActual := calcularEstado(frodo.tiempoMareo);

			casillaAnt := frodo.casilla; 

			if (frodo.energia<>0)
				then moverAFrodo(movimientoActual, estadoActual, frodo.casilla, filas, columnas);

			// Calculamos el nuevo nivel de energía
			{ Comprueba si la casilla es la [1,1] o la [N,M], en tal caso, no calcula
			energía }
                        if (((casillaAnt.fila = 1) AND (casillaAnt.columna = 1)) OR ((casillaAnt.fila = filas) AND (casillaAnt.columna = columnas)))
                                then frodo.energia := frodo.energia
				else calcularNivelEnergia(objetoActual, estadoActual, frodo.energia);
				
			
			mensaje:= '[' + converNum(casillaAnt.fila) + ',' + converNum(casillaAnt.columna) + '] - ' + verMovimiento(movimientoActual) + ' - ' + converNum(frodo.energia);
                	escribeLog(ficheroLog, mensaje);

			borrarObjeto(tablero,casillaAnt.fila, casillaAnt.columna);
			


                       finPartida := esFinDePartida(frodo.energia,estadoActual,objetoActual,frodo.casilla,filas,columnas);
                until(finPartida = TRUE);

		if (frodo.casilla.fila = filas) AND (frodo.casilla.columna = columnas) 
				then begin	
					mensaje:= '[' + converNum(frodo.casilla.fila) + ',' + converNum(frodo.casilla.columna) + '] - ' + verMovimiento(movimientoActual) + ' - ' + converNum(frodo.energia);
					escribeLog(ficheroLog, mensaje);
				end;
			
			

	end;

END.


