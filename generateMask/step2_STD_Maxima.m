clear; clc;
%%
x = [];
y = [];
z = [];
for k = 1:10
    k
    filename = num2str(k);
%     I = single(ReadTifStack(['.\splitStacks\' filename '.tif']));
%     Igauss = imgaussfilt(I, 1);
    % calculate average
%     Iavg = mean(Igauss,3);
%     Iavg(Iavg<0) = 0;
    % subtract average
%     Idiff = Igauss - Iavg;
%     Istd = std(I,[],3);
%     se = strel('disk', 200);
%     Ibg = imopen(Istd, se);
%     Istd = Istd - Ibg;
%      WriteTifStack(Istd, ['.\STD\' filename '.tif'], '32');
    %find maxima
%     Istd = single(ReadTifStack(['.\STD\' filename '.tif']));
Istd = imread('cali.tif',k);
%     load I
%     Istd = Istd .* single(I);
%     se = strel('disk', 200);
%     Ibg = imopen(Istd, se);
%     Istd = Istd - Ibg;
%     se = strel('disk', 50);
%     Ibg = imopen(Istd, se);
%     Istd = Istd - Ibg;
    im3 = imextendedmax(Istd, 500, 8);
    s=regionprops(im3,'Area','Centroid','PixelIdxList','MaxFeretProperties','MinFeretProperties');
    s1 = [];
    for n = 1:length(s)
        if s(n).Area >= 4 && s(n).Area <= 30 && (s(n).MaxFeretDiameter/s(n).MinFeretDiameter < 2)
            s1 = [s1; s(n)];
        end
    end
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
    saveas(gcf, ['.\maxima\' num2str(k) '.jpg']);
end
data = [x,y,z];
save data data