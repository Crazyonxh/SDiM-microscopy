filtersize = 13;
logstd = 2;
dilatesize = 31;
blendsize = 31;
blendstd = 5;
logthreshold = 0;

for k = 1:10
    temp = imread('cali.tif',k);
    temp1=temp(1:2000,:,:);
    img{k} = temp1;
end


% make brightness of all images equal
avg1 = mean2(img{1});
for ii = 2 : length(img)
    avgcur = mean2(img{ii});
    img{ii} = img{ii} + avg1 - avgcur;
end

imgfiltered = cell(size(img));

logfilter = fspecial('log', [filtersize filtersize], logstd);
se = strel('ball', dilatesize, dilatesize);

for ii = 1:length(img)    
    imgfiltered{ii} = imfilter(single(img{ii}), logfilter);
    imgfiltered{ii} = imdilate(imgfiltered{ii}, se, 'same');
end

fmap = ones(size(img{1}), 'single');
logresponse = zeros(size(img{1}), 'single') + logthreshold;

% Look for focal plane that has the largest LoG response (pixel in focus). 
for ii = 1:length(img)
    index = imgfiltered{ii} > logresponse;
    logresponse(index) = imgfiltered{ii}(index);
    fmap(index) = ii;
end

for k = 1:2560
    a = fmap(:,k);
    b = histcounts(a);
    [~,index] = max(b);
    stat(k) = index;
end
stat_smooth = medfilt1(stat, 100);
stat_smooth(1:100) = stat_smooth(101);
stat_smooth(end-100:end) = stat_smooth(end-101);
stat_smooth = round(stat_smooth);
hold on
% plot(stat)
plot(stat_smooth)
hold off

save stat_smooth stat_smooth



    