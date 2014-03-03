
program El_viaje_de_Frodo;

const MAX=500; {Declaracion de la dimension maxima del tablero}

type tArray=ARRAY[1..MAX,1..MAX] of integer; {declaracion de dimensiones del tablero}
     tFichTxt=text;

var CONTENIDO,DIRECCION:tArray;
    FilMax,ColMax,MAREO,energia:integer;
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
 /////////////CREAR FICHERO DE TEXTO///////////////////

 PROCEDURE Creafichero;
 begin
   assign(log,'recorrido.txt');
   rewrite(log);
   close(log);
 end;


 //////////////////////////////////////////////////////
 /////////////IMPRIME TEXTO////////////////////////////

 PROCEDURE Mensaje;
 begin
 append(log);

 IF DIRECCION[x,y]=0 THEN  writeln(log,'[',x,',',y,'] - NORTE - ',energia,' MAREO:',MAREO)
   ELSE IF DIRECCION[x,y]=1 THEN writeln(log,'[',x,',',y,'] -  SUR  - ',energia,' MAREO:',MAREO)
     ELSE IF DIRECCION[x,y]=2 THEN writeln(log,'[',x,',',y,'] -  ESTE - ',energia,' MAREO:',MAREO)
       ELSE IF DIRECCION[x,y]=3 THEN writeln(log,'[',x,',',y,'] - OESTE - ',energia,' MAREO:',MAREO);

 close(log);
 end;

 //////////////////////////////////////////////////////
 /////////////OBJETOS DEL TABLERO//////////////////////

 PROCEDURE ObjetosTablero(var CONTENIDO:tArray);
 begin

  IF CONTENIDO[x,y]=0 THEN energia:=energia
    ELSE IF CONTENIDO[x,y]=1 THEN energia:=energia+2
      ELSE IF CONTENIDO[x,y]=2 THEN MAREO:=MAREO+5
        ELSE IF CONTENIDO[x,y]=3 THEN if MAREO=0 then energia:=energia-3
                                                 else begin
                                                        Mensaje;
                                                        append(log);
                                                        writeln(log,'Frodo ha muerto a manos de un ORCO!!');
                                                        close(log);
                                                        energia:=-20;
                                                      end;

  CONTENIDO[x,y]:=0;{Una vez leido el contenido pone a 0 el contenido de la casilla}


 end;

 //////////////////////////////////////////////////////
 /////////////MOVIMIENTO DE FRODO NORMAL///////////////

 PROCEDURE Movimiento(var DIRECCION:tArray);
 BEGIN
 X:=1;  Y:=1;

 WHILE energia>0 DO
 begin

  IF MAREO=0 THEN
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

    IF ((x=FilMax)and(y=ColMax)) THEN begin
                                         Mensaje;
                                         energia:=-10;
                                       end;

    energia:=energia-1; {Descuenta un punto de vida al realizar el movimiento}
    ObjetosTablero(CONTENIDO);

  end; {FIN DEL WHILE NORMAL}

  IF MAREO>0 THEN
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

     IF ((x=FilMax)and(y=ColMax)) THEN begin
                                         Mensaje;
                                         energia:=-10;
                                       end;
     energia:=energia-2; {Descuenta un punto de vida al realizar el movimiento}
     MAREO:=MAREO-1;
     ObjetosTablero(CONTENIDO);

  end; {FIN DEL IF MAREADO}

 end;{FIN DEL WHILE ENERGIA>0}
 END; {FIN DEL PROCEDURE MOVIMIENTO}

 //////////////////////////////////////////////////////
 ////////////CUERPO DEL PROGRAMA PRINCIPAL/////////////

begin
 MAREO:=0;

 write('Introduzca el numero de Filas que representa el recorrido (1..N): ');
 readln(FilMax);
 write('Introduzca el numero de Columnas que representa el recorrido (1..M): ');
 readln(ColMax);
 write('Introduzca la Energia Inicial de Frodo. Numero entero entre 1 y ',FilMax * Colmax,': ');
 readln(Energia);

 /////////////////////////////////////////////////////
 ////////////LLAMADAS A PROCEDURES////////////////////

 Creafichero;
 LeerTablero(DIRECCION,CONTENIDO);

 IF ((CONTENIDO[1,1]<>0)OR(CONTENIDO[FilMax,ColMax]<>0)) THEN
                begin
                energia:=-20;
                append(log);
                writeln(log,'ERROR las casillas [1,1] y [',FilMax,',',ColMax,'] tienen que estar vacias');
                close(log);
                end

 ELSE Movimiento(DIRECCION);

 IF ((x=FilMax)and(y=ColMax)) THEN begin
                                         append(log);
                                         writeln(log,'Frodo ha llegado a el Monte del Destino, casilla[',FilMax,',',Colmax,'],');
                                         writeln(log,'consiguiendo destruir el anillo, HAS GANADO!!');
                                         close(log);

                                       end;
 IF energia>-10  THEN begin
                        Mensaje;
                        append(log);
                        writeln(log,'Frodo ha muerto, se ha quedado sin ENERGIA!!');
                        close(log);
                      end;

 end.
