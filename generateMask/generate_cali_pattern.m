I = zeros(768,1024,'uint8');
I(384,512)=255;
I(34:100:end, 62:100:end) = 255;
imshow(I);
imwrite(I, 'grid100.jpg');