%%
%Loading monte carlo simulations
emag1 = load('example/nyhead_MC1_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag2 =load('example/nyhead_MC2_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag3 =load('example/nyhead_MC3_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag4 =load('example/nyhead_MC4_holes_eth2_roastResult.mat').ef_mag;
emag5 =load('example/nyhead_MC5_holes_eth2_roastResult.mat').ef_mag;
emag6 =load('example/nyhead_MC6_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag7 =load('example/nyhead_MC7_holes_eth2_roastResult.mat').ef_mag;
emag8 =load('example/nyhead_MC8_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag9 =load('example/nyhead_MC9_holes_ethr2_FCz_roastResult.mat').ef_mag;
emag10 =load('example/nyhead_MC10_holes_eth2_roastResult.mat').ef_mag;
%%
% concatenate and calculate variance 
emag_all = cat(4, emag1,emag2,emag3,emag4,emag5,emag6,emag7,emag8,emag9,emag10);
varianceMatrix = var(emag_all, 0, 4);

stdMatrix = std(emag_all, 0, 4);
meanMatrix = mean(emag_all,4);
cvMatrix = stdMatrix ./ (meanMatrix + eps);

%visualize variance 
masks = load_untouch_nii('example/nyhead_T1orT2_masks.nii');
allMask = masks.img;

mappingFile = 'example/nyhead_T1orT2_seg8.mat';
load(mappingFile,'image','Affine');
mri2mni = Affine*image(1).mat;
cm = colormap(jet(2^11)); cm = [1 1 1;cm];
brain = (allMask==1 | allMask==2);
nan_mask_brain = nan(size(brain));
nan_mask_brain(find(brain)) = 1;

cvMatrix_plot = cvMatrix.*nan_mask_brain;

dataShowVal = cvMatrix_plot(~isnan(cvMatrix_plot(:)));
figName = 'Coefficient of Variation';
sliceshow(cvMatrix_plot,[],cm,[0 0.15],'Coefficient of Variation',[figName '. Click anywhere to navigate.'],[],mri2mni); drawnow
%%
%Draw the voxels with >20% difference
[x,y,z] = ind2sub(size(cvMatrix_plot), find(cvMatrix_plot >= 0.1));
highlight_voxels = zeros(394,466,620); 
idx = sub2ind(size(cvMatrix_plot), x, y, z);
highlight_voxels(idx) = 1;
highlight_voxels = highlight_voxels.*nan_mask_brain;
figName = 'Coefficient of Variation > 5%';
sliceshow(highlight_voxels,[],cm,[0 0.12],'CV',figName,[],mri2mni); drawnow
