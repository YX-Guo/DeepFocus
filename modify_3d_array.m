
function result = modify_3d_array(A, inds, tissue)
%assign specific voxels to corresponding tissue type
result = A;
for i = 1:size(inds,1)
    result(inds(i,1),inds(i,2),inds(i,3)) = tissue;
end
end