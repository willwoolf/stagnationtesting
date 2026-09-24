using StagnationDetection

## setup

n = 5
m = 1_000_000

rng = Xoshiro(1)

A = rand(rng, Float32SD, n, m)
B = randn(rng, Float32SD, m, n)

C = A * B

## diagnostics

net_absorptions.(C)

reportall()