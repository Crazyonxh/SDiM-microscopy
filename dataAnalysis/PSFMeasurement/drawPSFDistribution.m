mattrix=[32,24,17,16,15,25,34;18,11,6,2,3,14,20;19,10,7,0,1,13,21;23,9,8,4,5,12,22;29,31,27,26,28,30,33];
r=mattrix;
for ii=1:size(mattrix,1)
    for jj=1:size(mattrix,2)
        r(ii,jj)=h(mattrix(ii,jj)+1);
    end
end
imagesc(r);colormap jet