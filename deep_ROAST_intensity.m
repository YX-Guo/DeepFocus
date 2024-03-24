
function elec = deep_ROAST_opt(ROI,F_x_brain,F_y_brain,F_z_brain,ori)
% ROI: desired targeting region. Formatted as [x1,y1,z1;x2,y2,x2..], in
% voxel 
% F_xyz: 3-dimensional forward matrix (n_short * num_elec)
% nan_mask: mask out every voxel that's not grey/white matter

brain_mask = load('white_gray_mask.mat');
brain_mask = brain_mask.nan_mask;
x = size(brain_mask,1);
y = size(brain_mask,2);
z = size(brain_mask,3);

%Process indicator vector
%convert ROI voxel coordinates to down-sampled brain indice
ROI_ind = map_coordinate(ROI,brain_mask,x,y,z);
if (sum(find(ROI_ind))~=0 & length(ROI_ind)~=1)
    warning('Target region not in brain!');
    
else
    disp("ROI inside the brain")
end

target_sources = zeros(size(F_x_brain,1),1);
target_sources(ROI_ind) = 1;


safety_current = 1; 
num_elec = size(F_x_brain,2);

d0 = ones(size(F_x_brain,1),1);


%If not ignoring direction
cvx_begin
    disp('cvx_optimization')
    variable s(num_elec,1); 
  
    maximize(sum((ori'*(cat(2, F_x_brain*s,F_y_brain*s,F_z_brain*s)')*target_sources)));
    %Constraints
    subject to
    
    norm(s,1) <= 2*safety_current;
    sum(s) == 0;
    
cvx_end

elec = s;

end
