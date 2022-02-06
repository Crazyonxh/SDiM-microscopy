% for ii=1:10
%     new_name = [10 7 6 2 3 9  8 5 1 4  ];
%     tmp=imread(['C:\Users\BBNC\Downloads\1\acq_patterns\' num2str(ii,'%.4d') '.jpg']);
%     imwrite(tmp,['C:\Users\BBNC\Downloads\1\acq_patterns\new\' num2str(new_name(ii),'%.4d') '.jpg'])
% end
% %%
% clear
% img=imread('C:\Users\BBNC\Downloads\1\0.bmp');
% for ii=1:10
%     tmp0=imread(['C:\Users\BBNC\Downloads\1\mask\' num2str(ii) '.tif'])/255;
%     tmp(:,:,1)=tmp0;
%     tmp(:,:,2)=tmp0;
%     tmp(:,:,3)=tmp0;
%     outputIMG=tmp.*img;
%     imwrite(outputIMG,['C:\Users\BBNC\Downloads\1\new\' num2str(ii,'%.4d') '.bmp'])
% end
%%
close all
%clear
h=imread('C:\Users\BBNC\Downloads\1\depthBigSmooth-1.tif');
img=(imread('C:\Users\BBNC\Downloads\1\0.tif')-67)*2.5;
[ii,jj]=meshgrid(1:size(img,2),1:size(img,1));
figure(1)
surface(ii,jj,h,img,'FaceColor','texturemap', 'EdgeColor','none','CDataMapping','direct')
view(173,80);
axis off

%%
clear
h=imread('C:\Users\BBNC\Downloads\2\depth.tif');
img=(imread('C:\Users\BBNC\Downloads\2\0.tif')-67)*2.5;
[ii,jj]=meshgrid(1:size(img,2),1:size(img,1));
figure(2)
surface(ii,jj,h,img,'FaceColor','texturemap', 'EdgeColor','none','CDataMapping','direct')
view(173,85);
axis off
%%
clear
h=imread('C:\Users\BBNC\Downloads\3\depth.tif');
img=(imread('C:\Users\BBNC\Downloads\3\0.tif')-67)*2.5;
[ii,jj]=meshgrid(1:size(img,2),1:size(img,1));
figure(3)
surface(ii,jj,h,img,'FaceColor','texturemap', 'EdgeColor','none','CDataMapping','direct')
view(173,85);
axis off

%%
clear
t=200
t2=500
h=imread('E:\2\acq_1\depth-1.tif');
h=h((1+t):(2160-t),(1+t):(2560-t2));
img=(imread('E:\2\time.bmp')-0)*1;
img=img((1+t):(2160-t),(1+t):(2560-t2),:);

[ii,jj]=meshgrid(1:size(img,2),1:size(img,1));
figure(3)
surface(ii,jj,h,img,'FaceColor','texturemap', 'EdgeColor','none','CDataMapping','direct')
view(173,70);
axis off
figure;
figure;imagesc((h));colormap jet;axis off;view(173,70);