clear; clc;
% 
dmd_path = '.\align_patterns';
image_path = '.\align_images_6\sCMOS';
dmd_filenames = dir([dmd_path, '\*.jpg']);
image_filenames = dir([image_path, '\*.tif']);
N = length(dmd_filenames);
dmd_points = zeros(N, 2);
image_points = zeros(N, 2);
for n = 1:N
    dmd_file = imread([dmd_path '\' dmd_filenames(n).name]);
    [aa,bb]=find(dmd_file==max(max(dmd_file)));
    dmd_points(n,:) = [bb, aa];
    image_file = imread([image_path '\' image_filenames(n).name]);
    [aa,bb]=find(image_file==max(max(image_file)));
    image_points(n,:) = [bb, aa];
end
tform2 = maketform('affine', image_points(1:3,:), dmd_points(1:3,:));
tform2 = fitgeotrans(image_points,dmd_points,'affine');
save tform2 tform2