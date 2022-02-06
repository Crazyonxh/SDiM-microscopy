%%
clear; clc;
for thickness=11
for folderName=0:34
clear I0
thickness
folderName
filepath = ['D:\beads\20211112xiaofeiBeads' num2str(thickness) '\' num2str(folderName) '\'];
%mkdir([filepath 'result'])
mkdir(['D:\beads\results\' num2str(thickness) '\' num2str(folderName) ])
namelist = dir([filepath '\*.tiff']);
imgName0 = [namelist(1).folder '\' namelist(1).name];

for k = 1:length(namelist)
    imgName = [namelist(k).folder '\' namelist(k).name];
    I0(:,:,k) = imread(imgName);
end

%%
I0m=mean(I0,3);
I0m=uint16(I0m-double(squeeze(I0(:,:,1))));
im3 = imextendedmax(I0m, 100, 8);
s=regionprops(im3,'Area','Centroid','PixelIdxList','MaxFeretProperties','MinFeretProperties');

%%
s1=[];
x=[];
y=[];
imagesc(uint8(I0m/25));axis image;colormap jet;
for n = 1:length(s)
        if s(n).Area >= 1 && s(n).Area <= 50 && (s(n).MaxFeretDiameter/s(n).MinFeretDiameter < 2)
            s1 = [s1; s(n)];
        end
end

for n = 1:length(s1)
    a = s1(n).Centroid(1);
    b = s1(n).Centroid(2);
    x = [x;a];
    y = [y;b];
    hold on
    plot(a,b,'yo','MarkerSize',4);
end
%%
count=0;
for ii=1:size(x)
    if (x(ii)>200)&&(x(ii)<2000)&&(y(ii)>200)&&(y(ii)<2000)
        x(ii)=round(x(ii));
        y(ii)=round(y(ii));
        imgOutput=I0m(y(ii)-30:y(ii)+30,x(ii)-30:x(ii)+30);
        im2output = imextendedmax(imgOutput, 500, 8);
        soutput=regionprops(im2output,'Area','Centroid','PixelIdxList','MaxFeretProperties','MinFeretProperties');
        if length(soutput)==1
            %imagesc(imgOutput)
            %pause(0.1)
            count=count+1;
            outputVolume=I0(y(ii)-20:y(ii)+20,x(ii)-20:x(ii)+20,:);
            WriteTifStack(outputVolume, ['D:\beads\results\' num2str(thickness) '\' num2str(folderName) '\' num2str(count) '.tif'], '16');
        end
    end
end
end
end
%%
%[xx,yy,zz]=meshgrid(0.8*(-20:20),0.8*(-20:20), 2.5*(1:length(namelist)));