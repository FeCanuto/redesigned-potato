// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EnergyTrade{

    IERC20 private _token;

    struct Prosumer{
        uint16 uc;               //Unidade consumidora
        uint16 energiaConsumida; //Energia consumida em Kwh
        uint16 energiaInjetada;  //Energia injetada em Kwh
    }

    address public owner;
    address[] public prosumer;
    uint256 public prosumerCount;
    mapping(address => Prosumer) addressToProsumer;

    //São trechos de códigos que serão executados antes das funções.
    //Uma das aplicações mais conhecidas é a de controle de acesso 
    //para que somente endereços específicos possam executar uma função
    modifier isOwner() {
        require(msg.sender == owner , "Remetente invalido!");
        _;
    }

    function setProsumer(address endereco, uint8 unidadeConsumidora, uint8 consumida, uint8 injetada) public isOwner{

        if(addressToProsumer[endereco].uc != unidadeConsumidora){
            Prosumer memory newprosumer = Prosumer({
                uc : unidadeConsumidora,
                energiaConsumida : consumida,
                energiaInjetada : injetada
            }); 

        addressToProsumer[endereco] = newprosumer;
        prosumer.push(endereco);
        prosumerCount++;
        } else {
            addressToProsumer[endereco].uc = unidadeConsumidora;
            addressToProsumer[endereco].energiaConsumida = consumida;
            addressToProsumer[endereco].energiaInjetada = injetada;
        }

    }

    function pagarProsumerOwner(address endereco) public isOwner{
        require(addressToProsumer[endereco].energiaInjetada > addressToProsumer[endereco].energiaConsumida, "Energia consumida maior que a injetada");

        uint256 value = addressToProsumer[endereco].energiaInjetada - addressToProsumer[endereco].energiaConsumida;

        _token.transfer(endereco, value);
    }

    function info() public view returns(uint256){
        return _token.totalSupply(); 
    }
}

