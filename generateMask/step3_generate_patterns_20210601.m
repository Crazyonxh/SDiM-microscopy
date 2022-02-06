load stat_smooth
stat_smooth(:) = 10;
stat_smooth(280:2170)=9;
stat_smooth(380:2140)=8;
stat_smooth(520:2030)=7;
stat_smooth(570:1945)=6;
stat_smooth(620:1890)=5;
stat_smooth(690:1830)=4;
stat_smooth(765:1715)=3;
stat_smooth(865:1615)=2;
stat_smooth(940:1555)=1;
plot(stat_smooth)
savepath = '.\region\';
for k = 1:10
    I = zeros(2160, 2560, 'uint8');
    I(:,stat_smooth == k) = 255;
    imwrite(I, [savepath num2str(k) '.jpg']);
end
