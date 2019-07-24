**1. Create a cold node directory** 

​	In the Windows environment, create the CXcsCold directory in the same location as the hot node directory (the directory is CXcs), and create the CXCChain directory under CXcsCold, and copy the lic.b and cxcs.conf files in the hot node directory to the newly created one. In the CXcsCold/CXCChain directory.

​	In the ubuntu/mac environment, create the .cxcs-cold directory in the same location as the hot node directory (the directory is .cxcs), and create the CXCChain directory under .cxcs-cold and the lic.b in the hot node directory. Copy the cxcs.conf file to the newly created .cxcs-cold/CXCChain directory.

     Under the same machine, if you start the hot node and the cold node at the same time, you need to specify a different port, rpcport, in the cxcs.conf file.

**2. Start the cold node** 

When starting a cold node, please pay attention to the environment. Run the command (the following operations take the windows operation as an example. If you use it in the ubuntu/mac environment, please note that the following command replaces" " " with " ' " and "\"" with " " "):

```bash
cxcszc.exe CXCChain
```

**3. Create an address at the cold node** 

Execute call command on the cold node, and pay attention to the -cold parameter 

```bash
cxcsi.exe CXCChain -cold addnewaddr
```

​	Return to new Address 

**4. Import address** 

Import the address to the hot node: 

```bash
cxcsi.exe CXCChain  importaddr newAddress false
```

**5. Create a transaction** 

Create a transaction at the hot node. Before doing it, determine if there are assets in the newly created address: 

```bash
cxcsi.exe CXCChain setuprawsendfrom newAddress "{\"toAddr\":5}"
```

Return to hex1 of the transaction 

**In addition to creating a transaction on a hot node, you can choose to create a transaction using offline assembly:** 

**Query unspent output** 

Call command as follows: 

```bash
showunspent ( minconf maxconf addresses )
```

> Method parameter

| **Parameters** | Description                              |
| -------------- | ---------------------------------------- |
| minconf        | Minimum confirmation number of the block |
| maxconf        | Maximum confirmation number of the block |
| addresses      | The set of addresses to query            |

> e.g.

```bash
	showunspent 6 9999999 "[\"address1\",\"address2\"]"
```

> Return value 

```bash
	[                                         Array of json object
    {
      "txid" : "txid",                      The TXID
      "vout" : n,                           The vout value
      "address" : "address",                The address
      "account" : "account",                The associated "" for the default account
      "scriptPubKey" : "key",               The script key
      "amount" : x.xxx,                     The deal amount in yqf
      "confirmations" : n                   The number of confirms
    }
    ,...
  ]
```

**Assembly transaction:** 

1. Obtain the address by parsing the block, with unspent specifying the transfer object. Call command as follows: 

```bash
	setuprawdeal [{"txid":"id","vout":n},...] {"address":amount,...} ( [data] "action" )
```

> Method parameter

| **Parameters** | **Description**                                              |
| -------------- | ------------------------------------------------------------ |
| deals          | Transaction collection                                       |
| addresses      | Address: Quantity                                            |
| data           | Additional data                                              |
| action         | The default is "", lock (locking the given input in the wallet), sign (signing the transaction using the wallet key), lock, sign, send (signing and sending the transaction) |

> Return value 

```bash
	#If the action is "" or lock or send#  
	hex
	#if the action is "" in other ways
	{                                                        
	  "hex": "value",                                        The raw deal with signature(s) (hex-encoded string)
	  "complete": true|false                                 If deal has a complete set of signature (0 if not)
	}
```

> 2. Set the change address and specify the transaction fee through addrawchange 
>
> Call command 

```bash
	addrawchange "tx-hex" "address" ( fee )
```

> Method parameter

| Parameters | Description     |
| ---------- | --------------- |
| tx-hex     | Hex             |
| address    | Change address  |
| fee        | Handling charge |

> e.g.

```bash
	addrawchange "HEX""ADDR"
	addrawchange "HEX""ADDR" 0.01
```

> Return value 

```bash
	hex1
```

It is recommended to set the change address separately to prevent the repeated change due to vout parsing. 

**6. Analyze the transaction** 

```bash
cxcsi.exe CXCChain decoderawdeal hex1
```

	Return value example: 

```bash
{
    "txid" : "68b2484716b7ad59899a75f02d0ce13be65579681e8df2c090d53614fe43f147",
    "version" : 1,
    "locktime" : 0,
    "vin" : [
        {
            "txid" : "864bc3cf98110ffcfc9a9c68044f2c2aed0c3ff97941358c32b0be1d4b213248",
            "vout" : 0,
            "scriptSig" : {
                "asm" : "",
                "hex" : ""
            },
            "sequence" : 4294967295
        }
    ],
    "vout" : [
        {
            "value" : "5.00",
            "n" : 0,
            "scriptPubKey" : {
                "asm" : "OP_DUP OP_HASH160 ef533262be20d2a662b359f14daaa0bae9959471 OP_EQUALVERIFY OP_CHECKSIG",
                "hex" : "76a914ef533262be20d2a662b359f14daaa0bae995947188ac",
                "reqSigs" : 1,
                "type" : "pubkeyhash",
                "addresses" : [
                    "1NpSATuFgVSr2tftgXL9LELfjCq4ZK75Fy"
                ]
            }
        },
        {
            "value" : "4.999977",
            "n" : 1,
            "scriptPubKey" : {
                "asm" : "OP_DUP OP_HASH160 e10d3794f4ea95199a8af20301fc4ff0fd5c51ec OP_EQUALVERIFY OP_CHECKSIG",
                "hex" : "76a914e10d3794f4ea95199a8af20301fc4ff0fd5c51ec88ac",
                "reqSigs" : 1,
                "type" : "pubkeyhash",
                "addresses" : [
                    "1MWxsWBo5GzZ2gMy5DBBujrENj2BA2WGBs"
                ]
            }
        }
    ]
}
```

**7. Get vin information** 

Get the address scriptPubKey information using the txid and n of vin in the transaction details returned in the previous step: 

```bash
cxcsi.exe CXCChain showtxout 864bc3cf98110ffcfc9a9c68044f2c2aed0c3ff97941358c32b0be1d4b213248 0
```

Return value example: 

```bash
{
    "bestblock" : "0034e7373ba10ccbedf60518d496b6cbbb4861831dd0cf8cac0511c77a9dc973",
    "confirmations" : 104,
    "value" : "10.00",
    "scriptPubKey" : {
        "asm" : "OP_DUP OP_HASH160 e10d3794f4ea95199a8af20301fc4ff0fd5c51ec OP_EQUALVERIFY OP_CHECKSIG",
        "hex" : "76a914e10d3794f4ea95199a8af20301fc4ff0fd5c51ec88ac",
        "reqSigs" : 1,
        "type" : "pubkeyhash",
        "addresses" : [
            "1MWxsWBo5GzZ2gMy5DBBujrENj2BA2WGBs"
        ]
    },
    "version" : 1,
    "coinbase" : false
}
```

**8. Signature transaction** 

The hex1 in Step 5, the txid and n of vin in Step 6, and the scriptPubKey returned in Step 7, are safely transferred to the cold node, and the signature command is called: 

```bash
cxcsi.exe CXCChain  -cold signrawdeal hex1 "[{\"txid\":\"txid\",\"vout\":n,\"scriptPubKey\":\"scriptPubKey-hex\"}]"
```

Sign return value for hex2. 

If the address is not created on a cold node, execute the following command: 

```bash
cxcsi.exe CXCChain  -cold signrawdeal hex1 "[{\"txid\":\"txid\",\"vout\":n,\"scriptPubKey\":\"scriptPubKey-hex\"}]" "[\"privateKey\"]"
```

**9. Broadcasting transactions** 

Transfer the hex2 successfully signed in the previous step to the hot node for broadcast: 

```bash
cxcsi.exe CXCChain sendrawdeal hex2
```

Return to transaction txid after successful broadcast 

​	

