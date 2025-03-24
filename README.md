# My BQN library

BQN utilities. Scripts resembling these may become part of a standard library at some point but for now they're not. They shouldn't be assumed to be stable or well-tested.

For usage, see export lists at the top of each file. Run all tests with `bqn test/main.bqn`, or any individual test using the same name as the file in the main folder. Similarly, files in the `benchmark/` folder run and report on performance measurements for the script of the same name.

Text and file formats:
- strings.bqn: common string operations like split, replace, and so on (no regex)
- json.bqn: JavaScript Object Notation
- csv.bqn: Comma-Separated Value file format
- xml.bqn: eXtensible Markup Language

Math:
- primes.bqn: fast sieve with typical prime and factoring utilities
- matrix.bqn: matrix decompositions and tools; APL `⌹` is `Inverse⊘Solve`
- polynomial.bqn: complex polynomial tools and solvers
- min.bqn: optimization/minimization methods
- roots.bqn: find zeros of real-valued functions
- big{nat,int}.bqn: utilities for arbitrary-precision numbers. In progress.

Other:
- datetime.bqn: time and date, handling formats other than BQN's native `•UnixTime`
- hashmap.bqn: prototype for `•HashMap`, now obselete in CBQN
