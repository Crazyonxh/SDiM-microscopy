% dmd_path = 'D:\widefield_qt\build-widefield-Desktop_Qt_5_14_2_MSVC2017_64bit-Debug\align_patterns';
% image_path = 'D:\widefield_qt\build-widefield-Desktop_Qt_5_14_2_MSVC2017_64bit-Debug\align_images';
% dmd_filenames = dir([dmd_path, '\*.jpg']);
% image_filenames = dir([image_path, '\*.tif']);
% N = length(dmd_filenames);
% dmd_points = zeros(N, 2);
% image_points = zeros(N, 2);
% for n = 1:N
%     dmd_file = imread([dmd_path '\' dmd_filenames(n).name]);
%     [aa,bb]=find(dmd_file==max(max(dmd_file)));
%     dmd_points(n,:) = [bb, aa];
% %     image_file = imread([image_path '\' image_filenames(n).name]);
% %     [aa,bb]=find(image_file==max(max(image_file)));
% %     image_points(n,:) = [bb, aa];
% end
% image_points=[468 1590;
%     2060 1597;
%     1264 1063;
%     474 527;
%     2062 540];
% % tform2 = maketform('affine', image_points(1:3,:), dmd_points(1:3,:));
% tform2 = fitgeotrans(image_points,dmd_points,'affine');
% save tform2 tform2
load tform2
new_name = [10 7 6 2 3 9 8 5 1 4];
for k = 1:10
    A = imread(['.\region\' num2str(new_name(k)) '.jpg']);
    Rfixed = imref2d([768 1024]);
    B = imwarp(A,tform2,'OutputView',Rfixed);
%     B = imtransform(A,tform2,'XData',[1 1024],'YData',[1 768]);
    imwrite(B, ['.\acq_patterns\' num2str(k, '%04d') '.jpg']);
end