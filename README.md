1. Write zero knowledge circuits.
Our goal here is to create a circuit which when supplied with a private key, and an array of public keys, constructs a proof if and only if the private key corresponds to one of the public keys (i.e. it will fail if the private key does not correspond to one of the public keys as the constraint fails and no proof can be generated).


2. Generate solidity library to verify the written zero knowledge circuits.
3. Write out smart contract logic, and integrate the generated solidity library from step 2.
4. Deploy contracts.
5. Generate proof locally, and verify it on-chain.

1