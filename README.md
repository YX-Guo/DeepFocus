This is the code repository for the paper: DeepFocus: A Transnasal Approach for Optimized Deep Brain Stimulation of Reward Circuit Nodes

DeepFocus is built on ROAST. Please download ROAST first and replace functions with the ones in this repository. 

To generate the forward matrix:
- Run all the forward simulations with standard ROAST commands. Conduct simulation with 1mA at the active electrodes and -1mA at the return electrode (e.g. Iz). The transnasal electrode location used in the paper is included in nyhead_customLocations.
- Run assemble_leadfield_matrix function to generate the forward matrix in all 3 directions (x,y,z).

To target a specific ROI voxel inside the brain:
- Use the run_optimization function.
- Specify the opt_method as either “max-intensity” or “max-focality”, and more details about the optimization methods can be found in the paper.
- The ROI’s should be organized as N*3 matrix. Note that the optimization method targets these ROI’s one at a time.
- oris is the desired orientation of stimulation at the target ROI/s, and should also be organized as a N*3 matrix.
