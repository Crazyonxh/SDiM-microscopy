load tform2
A = imread(['C:\Users\bbnc\Desktop\000000.tif']);
% A = 255-A;
Rfixed = imref2d([768 1024]);
B = imwarp(A,tform2,'OutputView',Rfixed);
%     B = imtransform(A,tform2,'XData',[1 1024],'YData',[1 768]);
imwrite(B, ['C:\Users\bbnc\Desktop\11.jpg']);
