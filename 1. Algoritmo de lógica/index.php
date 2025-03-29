<?php
    $numeros = range(1, 100);
    unset($numeros[array_rand($numeros)]); // Se elimina un número al azar
    echo buscarNumeroFaltante($numeros);

    function buscarNumeroFaltante($numbers){
        // FUNCION USADA S = (n(n+1)) / 2
        $totalSum = (100 * (100 + 1)) / 2;
        $realSum  = array_sum($numbers);
        return $totalSum - $realSum;
    }