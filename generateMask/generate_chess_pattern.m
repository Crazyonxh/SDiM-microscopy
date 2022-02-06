close all;
clear all;
clc;
width=1024  ;      %pattern的宽
height=768     ;          %pattern的高
img_final=zeros(height,width);
reinforceconner=1       ;%是否加强角点 
row=10;                 %pattern中棋盘格的行数
col=13 ;              %pattern中棋盘格的列数
length=50;           %pattern中棋盘格的大小
org_X=(height-row*length)/2;        %pattern关于纵轴方向的位置，默认放在中间
org_Y=(width-col*length)/2;             %pattern关于横轴方向的位置，默认放在中间
  color1=1;
     color2=color1;
img=zeros(row*length,col*length);
for i=0:(row-1)
    color2=color1;
    for j=0:(col-1)
        if color2==1
        img(i*length+1:(i+1)*length-1,j*length+1:(j+1)*length-1)=color2;
        end
        %不加的话，可以注释掉
        %
        color2=~color2;
    end
    color1=~color1;
end
img_final(org_X:org_X+row*length-1,org_Y:org_Y+col*length-1)=img;
   img_final=~img_final;
     figure;imshow(img_final);   
     imwrite(img_final, 'cheesBoard.jpg','jpg');