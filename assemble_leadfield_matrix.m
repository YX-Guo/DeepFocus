function [forward_x_brain, forward_y_brain, forward_z_brain] = assemble_leadfield_matrix
    % Output the leadfield matrix in x,y,z direction (i.e. Ax, Ay, Az) and
    % include 50 electrodes (transnasal + scalp electrodes). 
    % Will first need to run forward simulations with active at each of the
    % 50 electrodes (+1mA) and return at Iz (-1mA).
    % YG edit, March 2024

    electrodes = load("example/elec_all.mat");
    electrodes = electrodes.elec_all;
    head_volume = load_untouch_nii('example/nyhead_T1orT2_masks.nii');
    x = 394;
    y = 466;
    z = 620;    
    
    forward_x = zeros(x*y*z,length(electrodes));
    forward_y = zeros(x*y*z,length(electrodes));
    forward_z = zeros(x*y*z,length(electrodes));
   
    return_elec = 'Iz';
    for i = 1:length(electrodes)
        
        elec_used = convertStringsToChars(electrodes(i));
        file = convertStringsToChars(strcat("example/nyhead_",elec_used,return_elec,"_leadfield_roastResult.mat"));
        load(file);
        %construct forward_x
        forward_x(:,i) = reshape(ef_all(:,:,:,1),x*y*z,1);
        %construct forward_y
        forward_y(:,i) = reshape(ef_all(:,:,:,2),x*y*z,1);
        %construct forward_z
        forward_z(:,i) = reshape(ef_all(:,:,:,3),x*y*z,1);
    
        
    end
    
    disp('finish generating large lead-field...');
    
    
    % Downsample the leadfield matrix to include only brain (gray/white
    % matter) voxels
    
    all_mask = head_volume.img;
    indSliceShow = [1,2]; %Showing white and gray matter
    mask = zeros(size(all_mask));
    for i=1:length(indSliceShow)
        mask = (mask | all_mask==indSliceShow(i));
    end
    
    nan_mask = nan(size(mask));
    nan_mask(find(mask)) = 1;
    nan_mask_tmp = reshape(nan_mask,x*y*z,1);
    num_elec = size(forward_z,2);
    nan_mask_tmp = repelem(nan_mask_tmp,1,[num_elec]);
    
    
    forward_x_masked = forward_x.*nan_mask_tmp;
    forward_x_short = forward_x_masked(find(~isnan(forward_x_masked))); %this is a column vector
    new_rows = length(forward_x_short)/num_elec;
    forward_x_brain = reshape(forward_x_short,new_rows,num_elec);
        
    forward_y_masked = forward_y.*nan_mask_tmp;
    forward_y_short = forward_y_masked(find(~isnan(forward_y_masked))); %this is a column vector
    new_rows = length(forward_y_short)/num_elec;
    forward_y_brain = reshape(forward_y_short,new_rows,num_elec);
        
    forward_z_masked = forward_z.*nan_mask_tmp;
    forward_z_short = forward_z_masked(find(~isnan(forward_z_masked))); %this is a column vector
    new_rows = length(forward_z_short)/num_elec;
    forward_z_brain = reshape(forward_z_short,new_rows,num_elec);
    disp('finish downsampling leadfield to brain sources only...')

end 