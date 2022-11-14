include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/escalarmulfix.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// PublicKey template derives the public key(out) from supplied private key(in) ont he babyJubJub curve

template PublicKey() {
  // private key needs to be hashed, and then pruned
  // to make sure its compatible with the babyJubJub curve
  signal private input in;
  signal output out[2];

  component privBits = Num2Bits(253);
  privBits.in <== in;

  var BASE8 = [
    5299619240641551281634865583518297030282874472190772894086521144482721001553,
    16950150798460657717958625567821834550301663161624707787222815936182638968203
  ];

  component mulFix = EscalarMulFix(253, BASE8);
  for (var i = 0; i < 253; i++) {
    mulFix.e[i] <== privBits.out[i];
  }

  out[0] <== mulFix.out[0];
  out[1] <== mulFix.out[1];
}

template ZkIdentidy(groupSize) {
    // Public Keys in the smart contract
    // This assumes that the publicKeys are all unique
    signal input publicKeys[groupSize][2];

    // Prover's private key
    signal private input privateKey;

    // Prover's derived public key
    component publicKey = PublicKey();
    publicKey.in <== privateKey;

    // Make sure that derived public key needs to matche to at least one public key in the
    // smart contract to validate their identity
    var sum = 0;

    // Create a component to check if two values are equal
    component equals[groupSize][2];
    for (var i = 0; i < groupSize; i++) {
        // Helper component to check if two values are equal
        // We can not use === cos this would fail if the predicate does not hold true
        equals[i][0] = isEqual();
        equals[i][1] = isEqual();

        equals[i][0].in[0] <== publicKeys[i][0];
        equals[i][1].in[1] <== publicKey.out[0];

        equals[i][1].in[0] <== publicKeys[i][1];
        equals[i][1].in[1] <== publicKey.out[1];

        sum += equals[i][0].out;
        sum += equals[i][1].out;
    }
}