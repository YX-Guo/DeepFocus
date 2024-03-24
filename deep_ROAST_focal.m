function elec = deep_ROAST_focal(ROI,F_x_brain,F_y_brain,F_z_brain,D,V,head_volume,ori,k)
% ROI: desired targeting region. Formatted as [x1,y1,z1;x2,y2,x2..], in
% voxel 
% F_xyz: 3-dimensional forward matrix (n_short * num_electrodes)
% nan_mask: mask out every vexel that's not grey/white matter



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
end

%Create forward matrix corresponding to ROI only
Ax_f = zeros(size(F_x_brain,1),size(F_x_brain,2));
Ay_f = zeros(size(F_x_brain,1),size(F_x_brain,2));
Az_f = zeros(size(F_x_brain,1),size(F_x_brain,2));
Ax_f(ROI_ind,:) = F_x_brain(ROI_ind,:);
Ay_f(ROI_ind,:) = F_y_brain(ROI_ind,:);
Az_f(ROI_ind,:) = F_z_brain(ROI_ind,:);



%hyper-parameter for controlling desired intensity
E_des = [0.001,0.01,0.1,0.5,1];

safety_current = 1;
num_elec = size(F_x_brain,2);
for i = 1:length(E_des)
    cvx_begin
                                                                                                                                                                                                                                                                     cvx_begin
        disp('cvx_optimization, with focality')
        variable s(num_elec,1);
        minimize(norm(D*V'*s,2))
    
        subject to
        norm(s,1) <= 2*safety_current;
        sum(s) == 0;
        disp("Desired Intensity")
        disp(E_des(i))
        sum(ori'*(cat(2, Ax_f*s,Ay_f*s,Az_f*s)')) == E_des(i);
    cvx_end
    if strcmp(cvx_status, 'Infeasible')
        disp('The problem is infeasible!');
        break
    end
    elec = s;
    disp("searched E_des value")
    
    tag = strcat(int2str(ROI(1)),"_",int2str(ROI(2)),"_",int2str(ROI(3)),"_k=",num2str(k),"_Edes=",num2str(E_des(i)),"_scalp_focal");
    [Emag, Ef] = calc_and_visual_res(elec,F_x_brain,F_y_brain,F_z_brain,head_volume,tag);
    res = struct('tag',tag,'electrode',elec,'Emag',Emag,'Ef',Ef,'ori',ori,'D',D,'V',V);
    file_name = convertStringsToChars(strcat("example/Deep_test_v3/BA25/",tag,".mat"));
    save(file_name,'res','-v7.3');
end
end
