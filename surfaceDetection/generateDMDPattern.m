clear; clc;
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: rename camera images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% rearrange the order of images, from small z to large z 
% for neural images, calculate the standard derivation over time in advance
new_name = [10 7 6 2 3 9 8 5 1 4]; 
filename = 'STD.tif';
K = 10; % number of z 
for k = 1:K    %load images
    I0(:,:,new_name(k)) = imread(filename, k);
end
saveastiff(I0, '.\output\STD_ordered.tif');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: feature detection with CV altorithms. 
% replace it with deep learning algorithms if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = [];
y = [];
z = [];
% detect the neurons
if ~exist('.\output\neurons_detected\', 'dir')
    mkdir('.\output\neurons_detected\');
end
for k = 1:10
    Istd = I0(:,:,k);
    scale = 1-k*0.05;   
    im3 = imextendedmax(Istd, 200*scale, 8);  %adjust the second parameter
    s=regionprops(im3,'Area','Centroid','PixelIdxList');%,'MaxFeretProperties','MinFeretProperties');
%     s1 = s;
% filter the regions if necesary 
    s1 = [];
    for n = 1:length(s)
        if s(n).Area >= 4 && s(n).Area <= 30 % && (s(n).MaxFeretDiameter/s(n).MinFeretDiameter < 2)
            s1 = [s1; s(n)];
        end
    end
%Plot the selected maximum local maximum on the images
    figure(1)
    imshow(Istd,[]);
    hold on
    for n = 1:length(s1)
        a = s1(n).Centroid(1);
        b = s1(n).Centroid(2);
        x = [x;a];
        y = [y;b];
        z = [z;k];
        plot(a,b,'yo','MarkerSize',4);
    end
    saveas(gcf, ['.\output\neurons_detected\' num2str(k) '.jpg']);
end
neurons_detected = [x,y,z];
save('.\output\neurons_detected.mat','neurons_detected');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: generate patterns
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[fitresult, gof] = createFit(x, y, z);
figure(2)
[xx,yy]=meshgrid(1:2560,1:2160);
zz = fitresult(xx, yy);
zz(zz>10)=10;
zz(zz<1)=1;
zz=round(zz);
figure(3)
plot3(xx,yy, zz);
if ~exist('.\output\region_in_focus\', 'dir')
    mkdir('.\output\region_in_focus\');
end
I_allz = zeros(2160, 2560);
for k = 1:10
    I = zeros(2160, 2560, 'uint8');
    I(zz==k)=255;
    I_allz = I_allz + single(I)/255.*I0(:,:,k);
    imwrite(I, ['.\output\region_in_focus\' num2str(k) '.jpg']);
end
saveastiff(I_allz, '.\output\acquired_std_simulated.tif');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Step 4: map to DMD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate a maptable if the DMD is not generated 
% [image_points,dmd_points]=cpselect(camera,DMD)
% tform2 = fitgeotrans(image_points,dmd_points,'affine');
% save tform2 tform2

%if  maptable is already generated
if ~exist('.\output\DMD_patterns\', 'dir')
    mkdir('.\output\DMD_patterns\');
end
load tform2.mat   %a map table between DMD and camera
for k = 1:10
    A = imread(['.\output\region_in_focus\' num2str(new_name(k)) '.jpg']);
    Rfixed = imref2d([768 1024]);
    B = imwarp(A,tform2,'OutputView',Rfixed);
%     B = imtransform(A,tform2,'XData',[1 1024],'YData',[1 768]);
    imwrite(B, ['.\output\DMD_patterns\' num2str(k, '%04d') '.jpg']);
end