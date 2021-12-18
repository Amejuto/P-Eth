## NFT - Programacion en Ethereum

**Se trata de una subasta de un NFT que tendrá las siguientes características:**

* La puja se realizará con el *Token propio PCY*.

* La Puja terminará el 24 de diciembre de 2021 a las 23:59:59.

* Para que cada pujante no se quede sin tokens o tenga pero no los suficientes para aumentar la puja, cada vez que un pujante supere la puja anterior, el anterior pujante mas alto recibira la cantidad pujada anteriormente.

**Dentro del contrato encontraremos las siguientes funciones y cada una tendrá unas características:**

1. Llamando a la función **`pujaActual`**:

    - Si esta dentro de fecha y hora para pujar, informa de cuanto es la puja actual, cuantas pujas llevan y si es suya.
    - Si esta fuera de fecha, dice la cantidad en la que ha acabado la puja.
    
2. Llamando a la función **`pujar`**:

    - Es la función con la que se permitirá realizar la puja pero tendrá unos requisitos:

       - Hay que saber si esta dentro de la fecha y hora, sino, no le dejará pujar y se le dirá en cuanto ha acabado la puja.
       - Hay que pujar una cantidad mayor que la puja actual.
       - Debe tener tokens suficiente para hacer la puja que quiere.
       - Si se cumplen todos los requisitos, entonces se transfiere la puja al contrato.
       - Antes de que la cantidad pujada sea ahora la puja actual, la anterior "puja actual" se le devuelve al anterior pujante.
       - Una vez se le devuelva la puja, ahora sí que la cantidad pujada se convierte en la puja actual y el pujante más alto es el que acaba de pujar.
       - Se suma una puja y así llevar el conteo de las pujas.

3. Llamando a la función **`get_NFT`**:

    - Permite que el pujante mas alto pida y se le envíe su NFT.
    
4. Llamando a la función **`enviarPujaAWallet`**:

    - Permite solo al que ha desplegado el contrato enviar la cantidad de la puja a su wallet.
    - Para ello la puja ha tenido que terminar y se le da permiso solo para enviarse la cantidad en la que ha terminado la puja.
