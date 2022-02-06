[fitresult, gof] = createFit(x, y, z);
[xx,yy]=meshgrid(1:2560,1:2160);
zz = fitresult(xx, yy);
zz(zz>10)=10;
zz(zz<1)=1;
zz=round(zz);
figure(2)
plot3(xx,yy, zz);
for k = 1:10
    I = zeros(2160, 2560, 'uint8');
    I(zz==k)=255;
    imwrite(I, ['.\region\' num2str(k) '.jpg']);
end
