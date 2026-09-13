%Hechos
periodo_valido(262).
periodo_valido(292).

%Reglas
es_divisor(N, X) :-
    Limite is N - 1,
    between(1, Limite, X),
    N mod X =:= 0.
        
suma_alicuota(N, Suma) :-
    findall(X, es_divisor(N, X), Divisores),
    sum_list(Divisores, Suma).
    
categoria(N, 'Administrative') :-
    N > 0,
    suma_alicuota(N, Suma),
    Suma > N.

categoria(N, 'Engineering') :-
    N > 0,
    suma_alicuota(N, Suma),
    Suma =:= N.
    
categoria(N, 'Humanities') :-
    N > 0,
    suma_alicuota(N, Suma),
    Suma < N.
    
paridad(Codigo, 'even') :- 0 is Codigo mod 2.
paridad(Codigo, 'odd') :- 1 is Codigo mod 2.

semestre_valido(Semestre) :-
    Semestre =:= 1 ; Semestre =:= 2.

codigo_valido(Codigo) :-
    Codigo >= 10000000,
    Codigo =< 99999999,
    PeriodoDigitos is Codigo // 100000,
    Anio is PeriodoDigitos // 10,
    Semestre is PeriodoDigitos mod 10,
    semestre_valido(Semestre),
    Periodo is Anio * 10 + Semestre,
    periodo_valido(Min),
    periodo_valido(Max),
    Periodo >= Min,
    Periodo =< Max.
    
    
analizar_codigo(Codigo, Periodo, Categoria, Consecutivo, Par) :-
    codigo_valido(Codigo),
    PeriodoDigitos is Codigo // 100000,
    CategoriaDigitos is (Codigo // 1000) mod 100,
    Consecutivo is Codigo mod 1000,
    Consecutivo >= 1,
    
    Anio is PeriodoDigitos // 10,
    Semestre is PeriodoDigitos mod 10,
    categoria(CategoriaDigitos, Categoria),
    paridad(Codigo, Par),
    
    Periodo = (Anio, Semestre).
    
imprimir_codigo(Codigo) :-
    analizar_codigo(Codigo, (Anio, Semestre), Categoria, Consecutivo, Par),
    write('20'), write(Anio), write('-'), write(Semestre), write(' '),
    write(Categoria), write(' '),
    write('num'), write(Consecutivo), write(' '),
    writeln(Par).
    
%Proceso y main
consultar :-
    write('Ingrese un código de 8 dígitos (campo vacío para terminar): '),
    read_line_to_string(user_input, Input),
    procesar_input(Input).
    
procesar_input(end_of_file) :-
    writeln('Entrada finalizada').
procesar_input("") :-
    writeln('Finalizando el programa').
procesar_input(Input) :-
    Input \= "",
    Input \= end_of_file,
    ( number_string(Codigo, Input),
        catch(imprimir_codigo(Codigo), _, fail)
    -> true
    ; writeln('Código inválido. No es un número de 8 dígitos o está fuera del rango')
    ),
    consultar.
    
generar :-
    writeln('Consultas en modo generar: '),
    findnsols(10, C, (between(29200000, 29299999, C), analizar_codigo(C, (29, 2), 'Engineering', _, _)), Ing2029),
    write('Carnés Engineering 2029-2 (Primeros 10): '), writeln(Ing2029),
    
    findnsols(10, C, (between(28100000, 28199999, C), analizar_codigo(C, (28, 1), 'Humanities', _, 'odd')), Hum2028),
    write('Carnés Humanities Odd 2028-1 (Primeros 10): '), writeln(Hum2028),
    
    findall(X, es_divisor(28, X), Divisores28),
    write('Divisores generados para 28: '), writeln(Divisores28).


main :-
    generar,
    consultar,
    halt.

:- initialization(main, main).
