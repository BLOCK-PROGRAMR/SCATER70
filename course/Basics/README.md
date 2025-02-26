## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

``` shell

 $ cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512  "setPassword(string)" "Hii Nithin" --rpc-url $RPC_URL --private-key $PRIVATE_KEY

blockHash            0x26af3e3a42fb44183ec405841e489ab7855dfca824cd5fe33c1cc85eb6d80d8c
blockNumber          3
contractAddress      
cumulativeGasUsed    45011
effectiveGasPrice    776110285
from                 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
gasUsed              45011
logs                 []
logsBloom            0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root                 
status               1 (success)
transactionHash      0x26ff5b5e69513179c2ddd3eec39dc6f8fa70748b6f9ed16dff00ee95e01ea0eb
transactionIndex     0
type                 2
blobGasPrice         1
blobGasUsed          
to                   0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```


```

### [S-#] Title (ROOT CAUSE + IMPACT)

**Description:** 

**Impact:** 

**Proof of Concept:**

**Recommended Mitigation:** 
```