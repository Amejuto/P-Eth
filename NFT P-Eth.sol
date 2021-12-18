//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// contrato de PCY "0x68a6d7156d63c16b17e21e69718f90f43dc9661f"

contract NFTPEthContract is ERC721URIStorage{


    uint256 private _pujaActual;
    uint256 private _pujadoresnum;
    address private _pujanteMasAlto;
    address private _owner;
    uint256 private _tokenId;
    uint256 MPuja = block.timestamp;
    IERC20 AMRToken;
    


    //La puja inicial es 0
    //El numero inicial de pujadores es 0
    //El token con el que se pujará es PCY, el token propio
    //El owner del contrato va a ser el que lo despliega
    //El tokenId es siempre 1 ya que solo se realizará la puja de un NFT

    constructor () ERC721("NFTPEthContract", "NFTP") {
        _owner = msg.sender;
        _pujaActual = 0;
        _pujadoresnum = 0;
        _tokenId = 1;
        
         AMRToken = IERC20 (0x68a6d7156d63c16b17e21e69718f90f43dc9661f);
    }



    //Solo se permitira usar las funciones ownable al que lo ha desplegado

    modifier ownable{
        require(msg.sender == _owner, "Solo el creador del contrato puede llamar esta funcion");
        _;
    }    
  


    //Llamando a la funcion pujaACtual se sabra lo siguiente:
    //Si esta dentro de fecha y hora (la fecha limite de puja es el 24 de diciembre de 2021 a las 23:59:59) para pujar,informa de cuanto es la puja actual, cuantas pujas llevan y si es suya
    //Si esta fuera de fecha, dice la cantidad en la que ha acabado la puja

    function pujaActual() public view returns (string memory) {
        if (MPuja <= 1640386799){ // 1640386799 es el timestamp del 24 de diciembre de 2021 a las 23:59:59
            if (_pujanteMasAlto == msg.sender){
                return string(abi.encodePacked("Llevamos ", uint2str(_pujadoresnum), " pujas. ","Tu puja es la mas alta con una cantidad de: ", uint2str(_pujaActual)));
                
            }
            return string(abi.encodePacked("Llevamos ", uint2str(_pujadoresnum), " pujas. ","La puja actual es de: ", uint2str(_pujaActual)));
        }
        return string(abi.encodePacked("La puja ha terminado en una cantidad de: ", uint2str(_pujaActual)));
}



    //Llamando a la funcion pujar se permitira pujar una cantidad de AMRToken, pero cumpliendo unos requisitos:
    //Hay que saber si esta dentro de la fecha y hora, sino, no le dejara pujar y se le dira en cuanto ha acabado la puja
    //Hay que pujar una cantidad mayor que la puja actual
    //Debe tener tokens suficiente para hacer la puja que quiere
    //Si se cumplen todos los requisitos, entonces se transfiere la puja al contrato.
    //Antes de que la cantidad pujada sea ahora la puja actual, la anterior puja actual se le devuelve al anterior pujante. Es lo que está dentro del "if". Solo si la puja actual era mayor que 0, ya que si es 0 nadie habia pujado todavia.
    //Una vez se le devuelva la puja, ahora si que la cantidad pujada se hace la puja actual y el pujante mas alto es el que acaba de pujar.
    //Se suma una puja y asi llevar el conteo de las pujas.

    function pujar(uint cantidad) public returns (string memory) {
        require(MPuja <= 1640386799, string(abi.encodePacked("Fecha limite de puja superada. La puja ha terminado en una cantidad de: ", uint2str(_pujaActual)))); 
        require(cantidad > _pujaActual, "La puja es menor a la actual");
        require(balanceOf[msg.sender] >= cantidad, "No tienes suficientes Coins");
        Transfer(msg.sender, this, cantidad);
        if (_pujaActual>0){         
            Transfer(_pujanteMasAlto, _pujaActual);
        }

       //Ahora hacemos que la puja mas alta es la que acaban de pujar y el pujante mas alto el que acaba de pujar
        
        _pujaActual = cantidad;
        _pujanteMasAlto = msg.sender;
        _pujadoresnum += 1;
        
        return string(abi.encodePacked("Has pujado ", uint2str(cantidad))); //Se le responde con el mensaje de lo que ha pujado
    }



    //Con la funcion get_NFT se permite que el pujante mas alto reciba su NFT

    function get_NFT(address pujanteMasAlto, string memory tokenURI) public returns (string memory) {
        if (MPuja > 1640386799){
        _mint(_pujanteMasAlto, _tokenId);
        _setTokenURI(_tokenId, tokenURI);

        return "https://gateway.pinata.cloud/ipfs/QmR1phARMP3chHYwvFTWzNdefyrY3A8NFjrGrEeQCyC8ND";
        }
    }



    //Con la funcion enviarPujaAWallet se le permite solo al que ha desplegado el contrato enviar la cantidad de la puja a su wallet.
    //Para ello la puja ha tenido que terminar y se le da permiso solo para enviarse la cantidad en la que ha terminado la puja.

    function enviarPujaAWallet() external ownable{
        if (MPuja > 1640386799){
            AMRToken.Allowance(this, _owner);
            AMRToken.Approve(_owner, _pujaActual);
            AMRToken.transferFrom(this, _owner, _pujaActual);

             }

    }


    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) return "0";
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

}