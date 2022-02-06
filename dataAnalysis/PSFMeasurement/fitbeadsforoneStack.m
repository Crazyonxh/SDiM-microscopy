warning off
count=1;

for folderName=33:33
filepath = ['D:\beads\results\11\29'  ];
imgName=[filepath '\18.tif'];

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
outputresult=fitresult.c1*sqrt(log(2))*2;
count=count+1;
catch
end
end
