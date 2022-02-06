%%
close all
warning off
clear
%%
filepath = 'C:\Users\weigu\Downloads\新建文件夹\';

namelist = dir([filepath '\*.bmp']);
%imgName0 = [namelist(1).folder '\' namelist(1).name];
%%
for ii=1:length(namelist)
    imgName0 = [namelist(ii).folder '\' namelist(ii).name];
    t=imread(imgName0);
    img(:,:,ii)=rgb2gray(t);
    imgrgb(:,:,:,ii)=t;
end
%%
img0=imresize(squeeze(img(:,:,1)),0.2);
ft = fittype( 'poly1' );
a(1)=1;
b(1)=0;
imgsmall(:,:,1)=img0;

for ii=1:9
    img1=imresize(squeeze(img(:,:,ii+1)),0.2);
    [xData, yData] = prepareCurveData( img1, img0 );
    [fitresult, gof] = fit( xData, yData, ft );

    a(ii+1)=fitresult.p1;
    b(ii+1)=fitresult.p2;
    imgsmall(:,:,ii+1)=img1.*a(ii+1)+b(ii+1);
end
%%
for ii=1:9
    imwrite(uint8(squeeze(imgsmall(:,:,ii+1))),['C:\Users\weigu\Desktop\images\correct\1000' num2str(ii) '.tif']);
end
averimg=uint8(squeeze(imgsmall(:,:,5)/2+imgsmall(:,:,7)/2));
    imwrite(averimg,['C:\Users\weigu\Desktop\images\correct\10005.tif']);
imgsmall(:,:,6)=averimg;

%%
filterMean=ones(3,3)/9;
varIMG=double(imgsmall);
for ii=0:9
    varIMG(:,:,ii+1)=(double(varIMG(:,:,ii+1))-double(conv2(double(varIMG(:,:,ii+1)),filterMean,'same'))).^2;
end
%%
img0=flip(varIMG,3);
img1=cat(3,img0,varIMG);
img2=cat(3,img1,varIMG);
filter=zeros(1,1,3);
filter(1,1,1)=1/3;
filter(1,1,2)=1/3;
filter(1,1,3)=1/3;
img3=convn(img2,filter,'same');
img4=img3(:,:,11:20);

for ii=0:9
    imwrite(uint8(squeeze(img3(:,:,ii+1))),['C:\Users\weigu\Desktop\images\correct2\1000' num2str(ii) '.tif']);
end


[maxI Index]=max(img4,[],3);
%index0=(imresize(Index,0.2));
imwrite(uint8(Index),'depth0.tif')
%imwrite(uint8(index0),'depth.tif')
%%
Index1=medfilt2(Index,[5,5]); 
imwrite(uint8(Index1),'depth1.tif')
%%

maxInd=max((uint8(Index1)),1);
resultIMG=maxInd;
for ii=1:size(imgsmall,1)
    for jj=1:size(imgsmall,2)
        resultIMG(ii,jj)=imgsmall(ii,jj,maxInd(ii,jj));
    end
end
resultIMGrgb(:,:,3)=maxInd;
% for ii=1:size(imgsmall,1)
%     for jj=1:size(imgsmall,2)
%         resultIMGrgb(ii,jj,:)=squeeze(imgrgb(ii,jj,:,maxInd(ii,jj)));
%     end
% end
%%
imwrite(uint8(resultIMG),'image.tif')
figure(1);imagesc(uint8(squeeze(imgsmall(:,:,1))))
figure(2);imagesc(resultIMG)
% figure(3);imagesc(resultIMGrgb)
% imwrite((resultIMGrg),'image.bmp')
%%
depthBig=imresize(Index1,[size(img,1),size(img,2)]);
imwrite(uint8(depthBig),'depthBig.tif')
%%
mask=zeros(109,164,9,'uint8');
for ii=1:9
    mask((floor(ii/3)+1):3:end,(mod(ii-1,3)+1):3:end,ii)=1;
    m=imresize(uint8(mask(:,:,ii)),[size(img,1),size(img,2)],'nearest');
    imwrite(m,['.\mask\' num2str(ii) '.tif'])
end
