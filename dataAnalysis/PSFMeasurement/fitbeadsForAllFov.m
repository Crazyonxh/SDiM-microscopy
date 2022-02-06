clear
warning off
count=1;
for thickness=0:10
    thickness
for folderName=0:34
filepath = ['D:\beads\results\' num2str(thickness) '\'  num2str(folderName) ];
namelist = dir([filepath '\*.tif']);
for k = 1:length(namelist)
    imgName = [namelist(k).folder '\' namelist(k).name];

I = ReadTifStack(imgName);

G = fspecial('gaussian', [5 5], 1);
Ig = imfilter(I,G,'same');
z=squeeze(max(max(Ig,[],1),[],2));
[Imax,maxFrame]=max(z);
[a,b]=find(Ig(:,:,maxFrame)==Imax);
toBefit=squeeze(I(:,:,maxFrame)-I(:,:,1));
toBefit2=toBefit(16:26,16:26);
s1=toBefit(a,:);
s1=s1(16:26);
x=0.8*(-5:5);
%[xx,yy]=meshgrid(0.8*(-5:5),0.8*(-5:5));

[xData, yData] = prepareCurveData( x, s1 );

% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [9050 0 0.73652278057542];

% Fit model to data.
try
[fitresult, gof] = fit( xData, yData, ft, opts );
FWHM2(count,1)=thickness;
FWHM2(count,2)=folderName;
FWHM2(count,3)=k;
FWHM2(count,4)=fitresult.c1*sqrt(log(2))*2;
count=count+1;
catch
end
end
end
end