https://ethereum.stackexchange.com/questions/23348/modify-truffle-console-command-to-execute-function-on-ropsten-deployed-contract

- How can I send them through the geth console?

```
If by that you mean how to setup up a geth node on the ropsten testnetwork and interact with it using truffle, keep reading.

In the terminal type: geth --testnet --rpc console

wait till the node is fully synced. You can check by typing eth.syncing if eth.syncing = false its done. (This part could take a while)

check your http endpoint it will look something like this: HTTP endpoint opened url=http://127.0.0.1:8545

In your truffle.js file add ropsten like so:

On windows its may be named truffle-config.js

networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
        host: "localhost",
        port: 8545,
        network_id: "*",
        gas: 4600000
    }
  }
If you don't already have an account type personal.newAccount() and follow the prompts. Then go to : http://faucet.ropsten.be:3001/ and add testnet ether to your account

Go back to the terminal and type personal.unlockAccount("your address")

Create a second terminal tab in you project directory and run truffle migrate --network ropsten

Assuming your contract and migrations has been setup properly. Your contract should be successfully deployed to the ropsten network.

Also a great tutorial on this: https://medium.com/@guccimanepunk/how-to-deploy-a-truffle-contract-to-ropsten-e2fb817870c1
```