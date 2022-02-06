%%
t=zeros(1024,768);
%%method 1 active detection
%% step1 generate mask
initi=10;
initj=10;
dist=100;
mask0=zeros(size(t,1),size(t,1),'uint8');
mask0(initi:dist:end,initj:dist:end)=1;
%% step2 imread detected image

%% step3 calibratie from one image for each depth

%% convolution to detect maximum intensity layer


%% method 2 cv detection
%% step1 generate mask
mask=zeros(109,164,9,'uint8');
for ii=1:9
    mask((floor(ii/3)+1):3:end,(mod(ii-1,3)+1):3:end,ii)=1;
    m=imresize(uint8(mask(:,:,ii)),[size(t,1),size(t,2)],'nearest');
    imwrite(m,['.\mask\' num2str(ii) '.tif'])
end
%% step2 imread detected image

%% step3 calibratie from one image for each depth

%% calculate to detect maximum intensity layer

