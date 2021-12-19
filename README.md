# My BQN library

BQN utilities. Scripts resembling these may become part of a standard library at some point but for now they're not. They shouldn't be assumed to be stable or well-tested.

For usage, see export lists at the top of each file, and function descriptions in the comments below.

- strings.bqn: common string operations like split, replace, and so on (no regex)
- primes.bqn: fast-ish sieve with typical prime and factoring utilities
- matrix.bqn: matrix decompositions and tools: APL `⌹` is `Inverse⊘Solve`
- min.bqn: optimization/minimization methods
- big{nat,int}.bqn: utilities for arbitrary-precision numbers. In progress.
- datetime.bqn: time and date, handling formats other than BQN's native `•UnixTime`
- hashmap.bqn: mutable hash table, a prototype for planned `•HashMap`
