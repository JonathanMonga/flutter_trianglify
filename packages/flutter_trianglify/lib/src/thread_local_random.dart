/// Generates Random numbers that are local to a thread thus
/// reducing instructions
/// needed to generate a random number.
class ThreadLocalRandom {
  int seed;

  ThreadLocalRandom([this.seed = 0x5DEECE66D]);

  /// Generates a psuedoRandom integer that has computational costs
  /// of several instructions less
  /// @param mod limit for generation of pseudo random number
  /// @return Random number between 0 and mod (exclusive)
  int nextInt(int mod) {
    if (mod != 0) {
      seed = (seed * 0x5DEECE66D + 0xB) & ((1 << 48) - 1);
      return (seed % mod);
    }

    return 0;
  }
}
