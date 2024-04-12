This is the code repository for the paper: DeepFocus: A Transnasal Approach for Optimized Deep Brain Stimulation of Reward Circuit Nodes

DeepFocus is built on [ROAST](https://github.com/andypotatohy/roast). Please download ROAST first and replace functions with the ones in this repository. 

To generate the forward matrix:
- Run all the forward simulations with standard ROAST commands. Conduct simulation with 1mA at the active electrodes and -1mA at the return electrode (e.g. Iz). The paper uses New York head model, and transnasal electrode locations are included in nyhead_customLocations.
- Run assemble_leadfield_matrix function to generate the forward matrix in all 3 directions (x,y,z).

To target a specific ROI voxel inside the brain:
- Use the run_optimization function.
- Specify the opt_method as either “max-intensity” or “max-focality”, and more details about the optimization methods can be found in the paper.
- The ROI’s should be organized as N*3 matrix. Note that the optimization method targets these ROI’s one at a time.
- oris is the desired orientation of stimulation at the target ROI/s, and should also be organized as a N*3 matrix.

References:
Huang, Y., Datta, A., Bikson, M., Parra, L.C., Realistic vOlumetric-Approach to Simulate Transcranial Electric Stimulation -- ROAST -- a fully automated open-source pipeline, Journal of Neural Engineering, Vol. 16, No. 5, 2019 (prefered reference)

Huang, Y., Datta, A., Bikson, M., Parra, L.C., ROAST: an open-source, fully-automated, Realistic vOlumetric-Approach-based Simulator for TES, Proceedings of the 40th Annual International Conference of the IEEE Engineering in Medicine and Biology Society, Honolulu, HI, July 2018

Huang, Y., Parra, L.C., Haufe, S.,2016. The New York Head - A precise standardized volume conductor model for EEG source localization and tES targeting. NeuroImage,140, 150-162
