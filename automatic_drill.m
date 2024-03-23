function [allMask, allMaskShow] = automatic_drill(allMask, allMaskShow)
%automatically drill holes on cribriform plate according to
%slicer-processed holes

crib_voxels = load_untouch_nii('example/Monte_Carlo_Crib/MC2_crib_plate.nii');
crib_voxels = crib_voxels.img;

new_tissue = 7;

[crib_x,crib_y,crib_z]= ind2sub(size(crib_voxels), find(crib_voxels~=0));
crib_coords = cat(2,crib_x,crib_y,crib_z);
allMaskShow = modify_3d_array(allMaskShow, crib_coords, new_tissue);
allMask = modify_3d_array(allMask, crib_coords, new_tissue);
end