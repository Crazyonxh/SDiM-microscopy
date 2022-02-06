clear
%parameters
NA=0.3


%
z=-240:1:240;
r=0:0.1:40;
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
figure(1)
imagesc(intensity);colormap hot
%%
for ii=1:10
    inten(:,:,ii)=intensity(:,(31+20*ii):(231+20*ii));
end
is=sum(inten,3);
%imagesc(is(301:501,:));colormap hot

%%
figure(1)
imagesc(intensity(301:501,141:341));colormap hot
t1=intensity(301:501,141:341)/max(max(intensity(301:501,141:341)));
imwrite(uint16(t1*255),'./psf0/psf1.tif')
%%
%parameters
NA=0.1


%%
z=-240:1:240;
r=0:0.1:40;
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
%%
figure(2)
imagesc(intensity2(301:501,141:341));colormap hot
t2=intensity2(301:501,141:341)/max(max(intensity2(301:501,141:341)));
imwrite(uint16(t2*255),'./psf0/psf2.tif')

 %%
is2=max(inten,[],3);
figure(3)
imagesc(is2(301:501,:));colormap hot
t3=is2(301:501,:)/max(max(is2(301:501,:)));
imwrite(uint16(t3*255),'./psf0/psf3.tif')
%%
is3=sum(inten,3);
figure(4)
imagesc(is3(301:501,:));colormap hot