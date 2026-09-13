
main :: IO()

esDivisor :: Int -> Int -> Bool
esDivisor numero x = (mod numero x) == 0

divisoresPropios :: Int -> [Int]
divisoresPropios n = filter(esDivisor n)[1 .. n-1]

sumaAlicuota :: Int -> Int
sumaAlicuota n = sum(divisoresPropios n)

clasificarCtgria :: Int -> String
clasificarCtgria n = 
    if (sumaAlicuota n>n) then
        "Administrative"
    else if (sumaAlicuota n==n) then
        "Engineering"
    else 
        "Humanities"
        
periodo :: Int -> String
periodo p = "20" ++ show (div p 10) ++ "-" ++ show (mod p 10)

paridad :: Int -> String
paridad n =
    if (mod n 2 == 0) then
        "even"
    else
        "odd"
        
periodoValido :: Int -> Bool
periodoValido p = p == 262 || p == 271 || p == 272 || p == 281 || p == 282 || p == 291 || p == 292

codigoValido :: Int -> Bool
codigoValido codigo =
    if (codigo < 10000000) then
        False
    else if (codigo > 99999999) then
        False
    else if (mod (div codigo 1000) 100) == 0 then
        False
    else if (mod codigo 1000) == 0 then
        False
    else
        periodoValido (div codigo 100000)
    
analizarCodigo :: Int -> String
analizarCodigo codigo =
    periodo (div codigo 100000) ++ " " ++
    clasificarCtgria (mod (div codigo 1000) 100) ++ " " ++
    ("num" ++ show (mod codigo 1000)) ++ " " ++
    paridad codigo
    
main = do
    
    putStrLn "Ingrese un código de 8 dígitos (o presione Enter para salir):"
    linea <- getLine
    if null linea
        then putStrLn "Programa finalizado"
    else do
        let intentos = (reads linea) :: [(Int, String)]
        if null intentos || (snd (head intentos)) /= ""
            then do
                putStrLn ("Código inválido: " ++ linea)
                main
            else do
                let codigo = fst (head intentos)
                if codigoValido codigo
                    then do
                        putStrLn (analizarCodigo codigo)
                        main
                    else do
                        putStrLn ("Código inválido: " ++ show codigo)
                        main

