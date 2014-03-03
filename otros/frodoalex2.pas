
program El_viaje_de_Frodo;

const MAX=500; {Declaracion de la dimension maxima del tablero}

type tArray=ARRAY[1..MAX,1..MAX] of integer; {declaracion de dimensiones del tablero}
     tFichTxt=text;

var CONTENIDO,DIRECCION:tArray;
    FilMax,ColMax,Energia,MAREO:integer;
    fil,col:1..MAX;
    X,Y:integer; {Declaracion de variables Auxiliares}
    log:tFichTxt;

 //////////////////////////////////////////////////////
 /////////////LEER DATOS DEL TABLERO///////////////////

 PROCEDURE LeerTablero(var DIRECCION,CONTENIDO:tArray);

  begin
  FOR fil:=1 to FilMax do
     FOR col:=1 to ColMax do
        begin
        write('Introduzca la Direccion de la casilla [',fil,',',col,']: ');
        readln(DIRECCION [fil,col]);

        write('Introduzca el Contenido de la casilla [',fil,',',col,']: ');
        readln(CONTENIDO [fil,col]);

     end;{Fin del FOR}

  end;{Fin de LeerTablero,procedimiento de lectura de datos introducidos por el usuario}

 //////////////////////////////////////////////////////
 /////////////IMPRIME TEXTO////////////////////////////

 PROCEDURE Mensaje;
 begin
 append(log);

 IF DIRECCION[x,y]=0 THEN  writeln(log,'[',x,',',y,'] - NORTE - ',energia)
   ELSE IF DIRECCION[x,y]=1 THEN writeln(log,'[',x,',',y,'] -  SUR  - ',energia)
     ELSE IF DIRECCION[x,y]=2 THEN writeln(log,'[',x,',',y,'] -  ESTE - ',energia)
       ELSE IF DIRECCION[x,y]=3 THEN writeln(log,'[',x,',',y,'] - OESTE - ',energia);

 close(log);

 end;

 //////////////////////////////////////////////////////
 /////////////OBJETOS DEL TABLERO//////////////////////

   PROCEDURE ObjetosTablero(var CONTENIDO:tArray);

begin

  IF CONTENIDO[x,y]=0 THEN energia:=energia;

  IF CONTENIDO[x,y]=1 THEN energia:=energia+2;

  IF CONTENIDO[x,y]=2 THEN MAREO:=MAREO+5;

  IF CONTENIDO[x,y]=3 THEN if MAREO=0 THEN energia:=energia-3
                           else begin
                                energia:=-20;
                                append(log);
                                writeln(log,'Frodo ha muerto a manos de un orco!!');
                                close(log)
                                end;

 CONTENIDO[x,y]:=0;{Una vez leido el contenido pone a 0 el contenido de la casilla}
 end;

 //////////////////////////////////////////////////////
 /////////////ESTADO DE FRODO NORMAL///////////////////

 PROCEDURE MovimientoNormal(var DIRECCION:tArray);

 begin

 X:=1;  Y:=1;

   WHILE energia>0 DO
     begin
   Mensaje;

   IF DIRECCION[fil,col]=0 THEN {Secuencia de movimientos en caso de introducir 0}
      if x>1 then x:=x-1
         else if y<colmax then y:=y+1
                 else if x<filmax then x:=x+1
                                  else y:=y-1;

   IF DIRECCION[fil,col]=1 THEN {Secuencia de movimientos en caso de introducir 1}
      if x<filmax then x:=x+1
         else if y>1 then y:=y-1
                 else if x>1 then x:=x-1
                             else y:=y+1;

   IF DIRECCION[fil,col]=2 THEN {Secuencia de movimientos en caso de introducir 2}
      if y<colmax then y:=y+1
         else if x<filmax then x:=x+1
                 else if y>1 then y:=y-1
                             else x:=x-1;

   IF DIRECCION[fil,col]=3 THEN {Secuencia de movimientos en caso de introducir 3}
      if y>1 then y:=y-1
         else if x>1 then x:=x-1
                 else if y>colmax then y:=y+1
                                  else x:=x+1;

   IF FilMax=1 THEN X:=1; {instruccion para resolver el tablero de una fila}
   IF ColMax=1 THEN Y:=1; {instruccion para resolver el tablero de una columna}

   energia:=energia-1; {Descuenta un punto de vida al realizar el movimiento}
   ObjetosTablero(CONTENIDO);
   Mensaje;

   IF ((energia>-10) and (energia<=0))THEN begin
                                              append(log);
                                              writeln(log,'Frodo ha MUERTO!!, Ha gastado su ENERGIA!!');
                                              close(log);
                                           end;
   IF ((x=FilMax)and(y=ColMax)) THEN  begin
                                         energia:=-20;
                                         append(log);
                                         writeln(log,'Frodo ha llegado a el Monte del Destino, casilla[',FilMax,',',Colmax,'],');
                                         writeln(log,'consiguiendo destruir el anillo, HAS GANADO!!');
                                         close(log);
                                       end;


     end;
   end;

 //////////////////////////////////////////////////////
 /////////////ESTADO DE FRODO MAREADO//////////////////

   PROCEDURE MovimientoMareado(var DIRECCION:tArray);

   begin


   WHILE ((MAREO>0) and (energia>0)) DO
       begin

     Mensaje;

     IF DIRECCION[fil,col]=0 THEN {Secuencia de movimientos en caso de introducir 0}
        if x<filmax then x:=x+1
          else if y>1 then y:=y-1
                 else if x>1 then x:=x-1
                           else y:=y+1;

     IF DIRECCION[fil,col]=1 THEN {Secuencia de movimientos en caso de introducir 1}
        if x>1 then x:=x-1
        else if y<colmax then y:=y+1
                 else if x<filmax then x:=x+1
                                else y:=y-1;

     IF DIRECCION[fil,col]=2 THEN {Secuencia de movimientos en caso de introducir 2}
         if y>1 then y:=y-1
           else if x>1 then x:=x-1
                   else if y>colmax then y:=y+1
                                  else x:=x+1;

     IF DIRECCION[fil,col]=3 THEN {Secuencia de movimientos en caso de introducir 3}
        if y<colmax then y:=y+1
           else if x<filmax then x:=x+1
                   else if y>1 then y:=y-1
                             else x:=x-1;

     IF FilMax=1 THEN X:=1; {instruccion para resolver el tablero de una fila}
     IF ColMax=1 THEN Y:=1; {instruccion para resolver el tablero de una columna}

     energia:=energia-2; {Descuenta un punto de vida al realizar el movimiento}
     MAREO:=MAREO-1;
     ObjetosTablero(CONTENIDO);
     Mensaje;

     IF ((energia>-10) and (energia<=0))THEN begin
                                              append(log);
                                              writeln(log,'Frodo ha MUERTO!!, Ha gastado su ENERGIA!!');
                                              close(log);
                                           end;



     IF ((x=FilMax)and(y=ColMax)) THEN  begin
                                         energia:=-20;
                                         append(log);
                                         writeln(log,'Frodo ha llegado a el Monte del Destino, consiguiendo destruir el anillo');
                                         close(log);
                                        end;

     IF CONTENIDO[x,y]=3 THEN if MAREO>0 then begin
                                                energia:=-20;
                                                append(log);
                                                writeln(log,'Frodo ha muerto a manos de un orco!!');
                                                close(log);
                                              end;

       end;
 end; {FIN del PROCEDURE Movimiento}

 //////////////////////////////////////////////////////
 /////////////ESTADO DE FRODO//////////////////////////

 PROCEDURE Estado;
 begin
  MAREO:=0;
  IF MAREO=0 THEN MovimientoNormal(DIRECCION);

  IF MAREO>0 THEN MovimientoMareado(DIRECCION);


 end;

 //////////////////////////////////////////////////////
 /////////////CREAR FICHERO DE TEXTO///////////////////

 PROCEDURE Creafichero;

 begin
   assign(log,'recorrido.txt');
   rewrite(log);
   close(log);
 end;

 //////////////////////////////////////////////////////
 ////////////CUERPO DEL PROGRAMA PRINCIPAL/////////////

begin
 write('Introduzca el numero de filas que representa el recorrido (1..N): ');
 readln(FilMax);
 write('Introduzca el numero de columnas que representa el recorrido (1..M): ');
 readln(ColMax);
 write('Introduzca la energia inicial de Frodo. Numero entero entre 1 y ',FilMax * Colmax,': ');
 readln(Energia);

 /////////////////////////////////////////////////////
 ////////////LLAMADAS A PROCEDURES////////////////////

 Creafichero;
 LeerTablero(DIRECCION,CONTENIDO);

  IF ((CONTENIDO[1,1] <>0 )OR(CONTENIDO[FilMax,ColMax] <>0))  THEN
                begin
                energia:=-20;
                append(log);
                writeln(log,'ERROR las casillas [1,1] y [',FilMax,',',ColMax,'] tienen que estar vacias');
                close(log);
                end

  ELSE estado;

 Estado;

end.
