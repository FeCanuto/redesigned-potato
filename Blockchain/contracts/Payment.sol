// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Payment {
    address origenTransferencia;
    address payable destinoTransferencia;
    uint256 montoTransferencia;

    constructor() {
        origenTransferencia = msg.sender;
    }

    event TransferirMonto(
        address payable _destinoTransferencia,
        address _origenTransferencia,
        uint256 montoTransferencia
    );

    function nuevaTransaccion(address payable _destinoTransferencia)
        public
        payable
        returns (bool)
    {
        destinoTransferencia = _destinoTransferencia;
        destinoTransferencia.transfer(msg.value);
        emit TransferirMonto(
            destinoTransferencia,
            origenTransferencia,
            msg.value
        );
        return true;
    }

    function verBalanceCuenta() public payable returns (uint256) {
        return origenTransferencia.balance;
    }
}
