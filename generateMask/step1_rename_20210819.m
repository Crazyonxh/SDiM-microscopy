clear; clc;

new_name = [10 7 6 2 3 9  8 5 1 4  ];
filepath = 'C:\Users\bbnc\Desktop\temp_data\20211130\2\cali\sCMOS\';
expType = 'vessel';

namelist = dir([filepath '\*.tif']);
imgName0 = [namelist(1).folder '\' namelist(1).name];
[R,C] = size(imread(imgName0));
nImgsAll = length(namelist);
nImgs = floor(nImgsAll/10);
K = 10;

I0 = zeros(R, C, K, 'uint16');

for k = 1:K    
    imgName = [namelist(k).folder '\' namelist(k).name];
    I0(:,:,new_name(k)) = ReadTifStack(imgName);
end
WriteTifStack(I0, 'cali.tif', '16');
%%
if strcmp(expType, 'neuron')
    for k = 1:K
        k
        tic
        I = zeros(R, C, nImgs, 'uint16');
        for n = 1:nImgs
            imgName = [namelist((n-1)*K+k).folder '\' namelist((n-1)*K+k).name];
            I(:,:,n) = ReadTifStack(imgName);
        end
        WriteTifStack(I, ['splitStacks\' num2str(new_name(k)) '.tif'], '16');
        Istd = std(single(I),[],3);
        WriteTifStack(Istd, ['.\STD\' num2str(new_name(k)) '.tif'], '32');
    end
end