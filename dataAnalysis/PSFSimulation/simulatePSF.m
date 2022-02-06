clear
%parameters
NA=0.3


%
z=-240:1:240;
r=0:0.2:200
N=NA^2;
u=2*pi*NA^2*z;
v=2*pi*NA*r;
[uu vv]=meshgrid(u,v);
fun1 = @(x,a,b) 2*exp(1i*a*x.^2/2).*besselj(0,b*x).*x;
%fun2 = @(x,a,b) 2*sin(1i*a*x.^2/2).*besselj(0,b*x).*x;

for ii=1:size(uu,1)
    ii
    for jj=1:size(uu,2)
        U(ii,jj) = integral(@(x)fun1(x,uu(ii,jj),vv(ii,jj)),0,1);
%        S(ii,jj)= integral(@(x)fun2(x,uu(ii,jj),vv(ii,jj)),0,1);
    end
end
I=N^2*(abs(U).^2);
%%
intensity=[flipud(I(2:end,:));I(1:end,:)];
imagesc(intensity);colormap hot
save('1.mat','I')
%%
for ii=1:10
    inten(:,:,ii)=intensity(:,(31+20*ii):(231+20*ii));
end
is=sum(inten,3);
figure(1)
imagesc(is(301:501,:));colormap hot

%%
figure(3)
imagesc(intensity(301:501,141:341));colormap hot
%%
%parameters
NA=0.1


%%
z=-240:1:240;
r=0:0.2:200;
N2=NA^2;
u=2*pi*NA^2*z;
v=2*pi*NA*r;
[uu vv]=meshgrid(u,v);
fun1 = @(x,a,b) 2*exp(1i*a*x.^2/2).*besselj(0,b*x).*x;
%fun2 = @(x,a,b) 2*sin(1i*a*x.^2/2).*besselj(0,b*x).*x;

for ii=1:size(uu,1)
    ii
    for jj=1:size(uu,2)
        U2(ii,jj) = integral(@(x)fun1(x,uu(ii,jj),vv(ii,jj)),0,1);
%        S(ii,jj)= integral(@(x)fun2(x,uu(ii,jj),vv(ii,jj)),0,1);
    end
end
I2=N2^2*(abs(U2).^2);
intensity2=[flipud(I2(2:end,:));I2(1:end,:)];
imagesc(intensity2(301:501,141:341));colormap hot

%%
 [xx yy]=meshgrid(-130:0.2:130,-130:0.2:130);
 [theta,rho] = cart2pol(xx,yy);
 %%
is2=max(inten,[],3);
figure(4)
imagesc(is2(301:501,:));colormap hot
%%
s=max(max(max(I)));

figure(1); img1=I(round(rho/0.2+1),241);imagesc(-130:0.2:130,-130:0.2:130,reshape(img1,1301,1301)*125);axis image;colormap hot;colorbar;img1=double(reshape(img1,1301,1301)/s);imwrite(img1,'./psf/1.tiff')
 figure(2); img2=I(round(rho/0.2+1),291);imagesc(-130:0.2:130,-130:0.2:130,reshape(img2,1301,1301)*125);axis image;colormap hot;colorbar;img2=double(reshape(img2,1301,1301)/s);imwrite(img2,'./psf/2.tiff')
 figure(3); img3=I(round(rho/0.2+1),341);imagesc(-130:0.2:130,-130:0.2:130,reshape(img3,1301,1301)*125);axis image;colormap hot;colorbar;img3=double(reshape(img3,1301,1301)/s);imwrite(img3,'./psf/3.tiff')
  figure(4); img4=I(round(rho/0.2+1),391);imagesc(-130:0.2:130,-130:0.2:130,reshape(img4,1301,1301)*125);axis image;colormap hot;colorbar;img4=double(reshape(img4,1301,1301)/s);imwrite(img4,'./psf/4.tiff')
 figure(5);   img5=I(round(rho/0.2+1),441);imagesc(-130:0.2:130,-130:0.2:130,reshape(img5,1301,1301)*125);axis image;colormap hot;colorbar;img5=double(reshape(img5,1301,1301)/s);imwrite(img5,'./psf/5.tiff')
%%
 figure(1); img11=I2(round(rho/0.2+1),241);imagesc(-130:0.2:130,-130:0.2:130,reshape(img11,1301,1301)*125);axis image;colormap hot;colorbar;img11=double(reshape(img11,1301,1301)/s);imwrite(img11,'./psf/11.tiff')
 figure(2); img12=I2(round(rho/0.2+1),291);imagesc(-130:0.2:130,-130:0.2:130,reshape(img12,1301,1301)*125);axis image;colormap hot;colorbar;img12=double(reshape(img12,1301,1301)/s);imwrite(img12,'./psf/12.tiff')
 figure(3); img13=I2(round(rho/0.2+1),341);imagesc(-130:0.2:130,-130:0.2:130,reshape(img13,1301,1301)*125);axis image;colormap hot;colorbar;img13=double(reshape(img13,1301,1301)/s);imwrite(img13,'./psf/13.tiff')
  figure(4); img14=I2(round(rho/0.2+1),391);imagesc(-130:0.2:130,-130:0.2:130,reshape(img14,1301,1301)*125);axis image;colormap hot;colorbar;img14=double(reshape(img14,1301,1301)/s);imwrite(img14,'./psf/14.tiff')
 figure(5);   img15=I2(round(rho/0.2+1),441);imagesc(-130:0.2:130,-130:0.2:130,reshape(img15,1301,1301)*125);axis image;colormap hot;colorbar;img15=double(reshape(img15,1301,1301)/s);imwrite(img15,'./psf/15.tiff')
%%
origIMG=imread('C:\Users\BBNC\Desktop\img1.tif');
convIMG1=double(conv2(imresize(origIMG,0.2),imresize(img1,0.2),'same'));
ss=max(max(convIMG1));
imwrite(uint16(convIMG1/ss*65535),'./output/1.tif')
convIMG2=double(conv2(imresize(origIMG,0.2),imresize(img2,0.2),'same'));imwrite(uint16(convIMG2/ss*65535),'./output/2.tif')

convIMG3=double(conv2(imresize(origIMG,0.2),imresize(img3,0.2),'same'));imwrite(uint16(convIMG3/ss*65535),'./output/3.tif')

convIMG4=double(conv2(imresize(origIMG,0.2),imresize(img4,0.2),'same'));imwrite(uint16(convIMG4/ss*65535),'./output/4.tif')

convIMG5=double(conv2(imresize(origIMG,0.2),imresize(img5,0.2),'same'));imwrite(uint16(convIMG5/ss*65535),'./output/5.tif')

%%
convIMG1=double(conv2(imresize(origIMG,0.2),imresize(img11,0.2),'same'));imwrite(uint16(convIMG1/ss*65535),'./output/11.tif')

convIMG2=double(conv2(imresize(origIMG,0.2),imresize(img12,0.2),'same'));imwrite(uint16(convIMG2/ss*65535),'./output/12.tif')

convIMG3=double(conv2(imresize(origIMG,0.2),imresize(img13,0.2),'same'));imwrite(uint16(convIMG3/ss*65535),'./output/13.tif')

convIMG4=double(conv2(imresize(origIMG,0.2),imresize(img14,0.2),'same'));imwrite(uint16(convIMG4/ss*65535),'./output/14.tif')

convIMG5=double(conv2(imresize(origIMG,0.2),imresize(img15,0.2),'same'));imwrite(uint16(convIMG5/ss*65535),'./output/15.tif')



