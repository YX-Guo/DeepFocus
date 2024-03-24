function [downsampled_inds] = map_coordinate(voxel_coordinates,nan_mask,x,y,z)
%nan_mask: only keeping grey/white matter voxels;
%voxel_coordinates: a vector of coordinates in original voxel space;
%after downsampling, it'll be a flat vector of reduced size
%down_sampled_ind: indices of the targeted voxels as a column vector

%First, check if targeted voxel coordinate is in grey/white matter. 
downsampled_inds = zeros(size(voxel_coordinates,1),1);
for i = 1:size(voxel_coordinates,1)
    voxel_coord = voxel_coordinates(i,:);
    row = voxel_coord(1);
    col = voxel_coord(2);
    page = voxel_coord(3);

    if (nan_mask(row,col,page)~=2 && nan_mask(row,col,page)~= 1)
        warning('target region is not inside brain (gray/white matter)!!')
        break
    else
        voxel_ind = (sub2ind(size(nan_mask),row,col,page));
        
        nan_mask_flat = (reshape(nan_mask,x*y*z,1));
        downsampled_ind = sum(~isnan(nan_mask_flat(1:voxel_ind)));
    end
    downsampled_inds(i) = downsampled_ind;
end
end


