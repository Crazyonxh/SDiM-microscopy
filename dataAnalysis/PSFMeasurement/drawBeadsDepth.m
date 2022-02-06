%%
close all
warning off
clear
%%
for ii=1:10
    ii
    for jj=0:35
        jj
        filepath = ['D:\beads\20211112xiaofeiBeads' num2str(ii) '\' num2str(jj) '\'];
        namelist = dir([filepath '\*.tiff']);
%imgName0 = [namelist(1).folder '\' namelist(1).name];
        for kk=1:length(namelist)
            imgName0 = [namelist(kk).folder '\' namelist(kk).name];
            t=imread(imgName0);
            img(:,:,kk)=double(t);
            s(kk)=sum(sum(sum(img(:,:,kk).^2)));
        end
        [inten index(ii,jj+1)]=max(s);
    end
end

%%
for ii=1:10
    for jj=2:36
        depth(ii,jj-1)=(index(ii,jj)-1)*0.0025+z(ii);
    end
end
%%
for jj=1:35
    subplot(5,7,jj)
    plot(glass,depth(:,jj))
end
%%
depthMin=max(depth);
for jj=1:32
    depth0(:,jj)=-(depth(:,jj)-depthMin(jj));
end
for jj=1:32
    subplot(5,7,jj)
    plot(glass,depth0(:,jj))
end
csvwrite('depthForBeads.csv',depth0)
%%
count=2;
Dtable=zeros(321,3);
for ii=1:32
    for jj=1:10
        Dtable(count,1)=ii;
        Dtable(count,2)=glass(jj);
        Dtable(count,3)=depth0(jj,ii);
        count=count+1;
    end
end
%%
csvwrite('Dtable.csv',Dtable)
%%

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'LAR';

% Fit model to data.

for ii=1:32
   x=glass;
   y=depth0(:,ii);
   [xData, yData] = prepareCurveData( y, x );
    [fitresult, gof] = fit( xData, yData, ft, opts );
    p(ii+1)=fitresult.p1

end
%%
csvwrite('p.csv',p')
