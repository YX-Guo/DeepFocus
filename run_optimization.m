function [elec,Emag,Ef] = run_optimization(opt_method,ROIs,oris)
    % opt_method: optimization method, either max-intensity or max-focality
    % ROIs: target ROI's, as N*3 matrix.
    % oris: desired orientation for each target, as N*3 matrix. 
    head_volume = load_untouch_nii('example/nyhead_T1orT2_masks.nii');
    load('example/elec_all.mat');
    load('example/forward_x.mat');
    load('example/forward_y.mat');
    load('example/forward_z.mat');
    disp('finish loading forward matrix...')

    if strcmpi(opt_method,'max-intensity')
        for i = 1:size(ROIs,1)
            ROI = ROIs(i,:)
            ori = oris(i,:)';            
            elec = deep_ROAST_intensity(ROI,forward_x_brain,forward_y_brain,forward_z_brain,ori);
            %save electrode config
            tag = strcat(int2str(ROI(1)),"_",int2str(ROI(2)),"_",int2str(ROI(3)),"_DeepFocus");
            [Emag, Ef] = calc_and_visual_res(elec,forward_x,forward_y,forward_z,head_volume,tag);
            res = struct('tag',tag,'electrode',elec,'Emag',Emag,'Ef',Ef,'ori',ori);
            file_name = convertStringsToChars(strcat("example/max_intensity_results/",tag,".mat"));
            save(file_name,'res','-v7.3');
        end
    else
        for i = 1:size(ROIs,1)
            ROI = ROIs(i,:)
            ori = oris(i,:)'; 
            k = 1000; %cancel region: ROI and its k-nearest neighbors
            disp("focal search: start svd...")
            [U,D,V] = svd_Ac(forward_x_brain,forward_y_brain,forward_z_brain,ROI,k);
            disp("finish svd!")
            elec = deep_ROAST_focal(ROI,forward_x_brain,forward_y_brain,forward_z_brain,D,V,head_volume,ori,k);
        end
    end

    
    
end





