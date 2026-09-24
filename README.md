# Testing Stagnation Detection

A collection of scripts and notebooks for generating the results produced in Julia for "Analysis and Detection of Stagnation in Floating-Point Summation" (Mantas Mikaitis and William Woolfenden, 2026, in progress).

## Numerical results

### Summation

Folder `sums`, script `main.jl` produces results for stagnation in vector summation and dot products of uniform distribution vectors in single and half precision.

### Matrix multiplication

Folder `matmul`, script `demo.jl` performs large rectangular matrix multiplication with stagnation detection and uses the diagnostic functions `net_absorptions` and `reportall`.

### Shallow water simulation

Folder `shallowwaters`, notebook `results.ipynb`. Results of shallow water simulations for different timestep values, grid resolutions and number formats are provided in `shallowwaters/data`. The notebook chapter **Simulations** can produce these results, **Figures** uses the data to produce the figures seen in the paper.

## Performance analysis

### Benchmarking

Folders `bench/sum`, `bench/dot`, `bench/matmul` contain scripts `main.jl` that test vector sums, dot products and matrix multiplication in double, single and half precision.

Notebook `summation.ipynb` produces the figure comparing MPFR, stagnation detection and regular recursive summation in double precision.

Script `memory_usage.jl` reports the storage cost of scalars, vectors and matrices of different sizes with stagnation detection.
