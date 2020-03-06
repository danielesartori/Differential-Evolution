# Differential-Evolution
Some alternative implementations of the Differential Evolution optimization algorithm

This repository includes four alternative implementations of Differential Evolution optimization algorithm, the differences being in mutation scheme (for DE_rand1, DE_best1, DE_best2) and in the self adaptation (jDE_best2). More information about the algorithm can be found in the following papers:

- Mallipedi, Suganthan, Pan, Tasgetiren, "Differential evolution algorithm with ensemble of parameters and mutation strategies", https://www.sciencedirect.com/science/article/abs/pii/S1568494610001043

- Brest, Greiner, Boskovic, Mernik, Viljem Zumer, "Self-Adapting Control Parameters in Differential Evolution, A Comparative Study on Numerical Benchmark Problems", https://ieeexplore.ieee.org/abstract/document/4016057


DE_rand1, DE_best1, DE_best2 have the following inputs:
- NP: size of the population
- n_gen: number of generations
- F: scale factor
- CR: crossover rate
- Xbound: parameters search boud (matrix with dimension 2 x number of parameters to be optimized)
- objf_var: struct containing the variables used as input of the objective function to be optimize
- objf_k: struct containing some constants used as input of the objective function to be optimize and as control for the DE optimization. These latest two are objf_k.n_objf_perf (number of performance contributing to the calculation of the objective function) and objf_k.df_lim (percentage limit of objective function variation for early optimization stop)

As an alternative to F and CR, jDE_best2 has:
- Finit: initial value of scale factor
- CRinit: initial value of crossover rate


DE_rand1, DE_best1, DE_best2 have the following outputs:
- Xopt: final vector of the optimal values
- Xgen: matrix of the evolutions of the temporary optimal values along the generations
- objf_perf_min: matrix of the evolutions of the obective function and its contributions along the generations

In addition, jDE_best2 has:
- Fgen: evolution of scale factor along the generations
- CRgen: evolution of crossover rate along the generations


For all DE optimization implementations, it is necessary to define a Matlab function (here called eval_obj_fun) to assess the objective function of interest for the studied case.

