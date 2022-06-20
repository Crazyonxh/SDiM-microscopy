%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%import the dataset all_infered_results.mat from folder 20211205_ai148_visual_stimulation_2
%brain_region 1*5540 each cell is the name of brain area
%valid_C a matrix of 5540cells*10012 time points 

%download circularGraph function if required https://github.com/paul-kassebaum-mathworks/circularGraph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% record the brain regions we imaged in a list brain_region and sort neurons by brain region names
%sort the valid_C in valid_C1
% get a list of brain region names by neuron order
regionList=[];
count=0;
%for each neuron in the current list, check the whole list. If this item is
%not in the list, the index is zero
for ii=1:size(brain_region,2)
    iminList(ii)=0;
    %check for each item in current brain regions, if this item is included
    for jj=1:length(regionList)
            iminList(ii)=iminList(ii)||strcmp(brain_region{1,ii},regionList{jj});
    end
    %if the index is zero, include the item name in a list name of
    %regionList
    if  (iminList(ii)==0)
        count=count+1;
        regionList{count}=brain_region{1,ii};
    end
end
% for each region, create a list that include the neuron index in the variable brain_region
for ii=1:length(regionList)
    regionNeuronList{ii}=[];
    for jj=1:5540
        if(strcmp(regionList{1,ii},brain_region{jj}))
            regionNeuronList{ii}=[regionNeuronList{ii} jj];
        end
    end
end

%sort neurons by brain region names  
valid_C1=valid_C*0;
count=1;
for ii=1:length(regionNeuronList)
    for jj=1:size(regionNeuronList{ii},2)
        valid_C1(count,:)=valid_C(regionNeuronList{ii}(1,jj),:);
        count=count+1;
    end
end




%% figure 3b: plot trace of neurons
figure(1)
imagesc(valid_C1)
caxis(gca,[0,100])
colormap parula
title('Neural Traces')

%% figure 3c:caculate the correlation of neuronal trace and plot it with a circularGraph
valid_C2=valid_C1';
C2=corr(valid_C2,valid_C2);

seed=rand(5540,1)>0.8;
seedPos=find(seed==1);
C4=C2(seedPos,seedPos);
C5=abs(C4)>0.3;
figure(2)
%circularGraph(C5);
%%
%index of neurons in each brain area
for ii=1:length(regionNeuronList)
    legthAreaNeurons(ii)=size(regionNeuronList{ii},2);
end
%number of neurons in each brain area
for ii=1:length(regionNeuronList)
    legthAreaNeuronsSum(ii)=sum(legthAreaNeurons(1:ii));
end

%% Fig 3d1
%for each brain areas, calculate correlations of all pairs of neurals and calculate the average  
C=corr(valid_C',valid_C');
for ii=1:size(regionList,2)
    temp1=regionNeuronList{1,ii};
    NT1=valid_C(temp1,:);
    for jj=1:size(regionList,2)
        temp2=regionNeuronList{1,jj};
        NT2=valid_C(temp2,:);
        temp=corr(NT1',NT2');
        corrEff2(ii,jj)=mean(mean((temp)));
    end
end
%exclude the auto correlations for the neuron itself

for ii=1:size(regionList,2)
    temp=regionNeuronList{1,ii};
    CT=C(temp',temp');
    CT0=CT(find(CT<0.999));
    corrEff2(ii,ii)=mean(mean((CT0)));
end
figure(40)
imagesc(corrEff2)
title('Pair-wise single neural correlation and average them over brain areas')
%% Fig 3d2
%sum the neural acitivities in each brain area as the area activity, and calculate their correlaiton 
for ii=1:(size(regionList,2))
    temp=regionNeuronList{1,ii};
    NT1=valid_C(temp,:);
    averNT(ii,:)=mean(NT1,1);
end
brainAreaCorr=corr(averNT');
figure(41)
imagesc((brainAreaCorr))
title(' Correlation of the brain area activities')
%% paired t-test
[h,p0]= ttest(abs(corrEff2(:)),abs(brainAreaCorr(:)));
%% figure S3a
%check the relatonship of correlation with distance, and fit it
distance=C2;
for ii=1:5540
    for jj=1:5540
        distance(ii,jj)=sqrt((centered_neuron_AP(1,ii)-centered_neuron_AP(1,jj))^2+(centered_neuron_ML(1,ii)-centered_neuron_ML(1,jj)).^2);
    end
end
dis2Coore=[reshape(distance,[],1) reshape(C,[],1)];

xx=dis2Coore(:,1);yy=dis2Coore(:,2);
yy(find(xx<eps),:)=[];
xx(find(xx<eps),:)=[];
seed=rand(size(xx,1),1);
xx2=xx(seed>0.9999);
yy2=yy(seed>0.9999);
[xData, yData] = prepareCurveData( xx, yy );

% Set up fittype and options.
ft = fittype( 'poly1' );
figure(10)
scatter(xx2,yy2,10)
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
hold on;plot((0:0.01:1.2),(0:0.01:1.2)*fitresult.p1+fitresult.p2,'linewidth',3)

xlim([0 1]);ylim([-0.2 0.4])
title('correlation with distance')

[r1,p1]=corr(xx,yy,'type','Spearman');
[r2,p2]=corr(xx,yy,'type','Pearson');
%test the significance of fitting
mdl = fitlm(xx,yy);
mdl.Coefficients
a1=anova(mdl,'summary');

%% figure S3b
%correation abs vs distance
[xData, yData] = prepareCurveData( xx, abs(yy) );

% Set up fittype and options.
ft = fittype( 'poly1' );
figure(11)
scatter(xx2,abs(yy2),10)
% Fit model to data.
[fitresult, gof2] = fit( xData, yData, ft );
hold on;plot((0:0.01:1.2),(0:0.01:1.2)*fitresult.p1+fitresult.p2,'linewidth',3)

xlim([0 1]);ylim([0 0.15])
title('abs distance with time')
[r3,p3]=corr(xx,abs(yy),'type','Spearman');
[r4,p4]=corr(xx,abs(yy),'type','Pearson');

%test the significance of fitting
md2 = fitlm(xx,abs(yy));
md2.Coefficients
a2=anova(md2,'summary');

%% figure 3e1
%save corrlation and distance for box plot in seaborn
zz=round(xx*10);
Ntable=[zz yy];
csvwrite('CorrelationByDistanceGroup.csv',Ntable)
%% figure 3e2
%save abs corrlation and distance for box plot in seaborn
zz=round(xx*10);
Ntable=[zz yy];
csvwrite('AbsCorrelationByDistanceGroup.csv',abs(Ntable))
%%  figure 3g
%plot high correlated connectioons,find there are some hub neurons
figure(12);
scatter(centered_neuron_AP,centered_neuron_ML,10,'b')
count=0;
for ii=1:size(C,1)
    for jj=(ii+1):size(C,2)
        if (abs(C(ii,jj))>0.55)
            hold on
            plot([centered_neuron_AP(ii);centered_neuron_AP(jj)],[centered_neuron_ML(ii);centered_neuron_ML(jj)],'lineWidth',0.5)
            count=count+1;
        end
    end
end
axis off
title('Hub Neurons')




%% figure 3h
deg2=sum(abs(C));

figure(17)
t=deg2<400;
scatter(centered_neuron_AP(t),centered_neuron_ML(t),10,'y')
axis off
hold on
t=((deg2>=400)&(deg2<450));
scatter(centered_neuron_AP(t),centered_neuron_ML(t),10,'b','fill')
hold on
t=((deg2>=450)&(deg2<500));
scatter(centered_neuron_AP(t),centered_neuron_ML(t),20,'g','fill')
hold on
t=(deg2>=500);
scatter(centered_neuron_AP(t),centered_neuron_ML(t),40,'r','fill')

title('high absolute degree neurons')

%% figure 3b2
B=sort(deg2,'descend');
ind=find(deg2>=B(10));
init=0;
figure(18);
for ii=1:10
  hold on
  init=init-100;
  plot(valid_C(ind(ii),:)-init)
end
box on
xlim([0 10000])
ylim([90 1100])
title('neural trace of hub neurons')

%%
%correlation except auto-correlations
% CT1=[];
% for ii=1:size(regionList,2)
%     temp=regionNeuronList{1,ii};
%     ind1=valid_C(temp,:);
%     CT=C(temp,temp);
%     CT0=CT(find(CT<0.999));
%     CT0=[CT0 ii*ones(size(CT0))];
%     CT1=[CT1;CT0];
% end
% temp=[yy 15*ones(size(yy))];
% CT1=[CT1;temp];
% % figure
% % boxplot(abs(CT1(:,1)),CT1(:,2))
% csvwrite('CT3.csv',abs(CT1))


%% figure S4
figure(20)
histogram(deg2,100,'EdgeColor','none');
hold on
[f,xi] = ksdensity(deg2);plot(xi,f)
plot(xi,f*30000,'linewidth',2)
xi2=xi(1,30:100);
f2=f(1,30:100)*30000;
hold on;
xx=200:600;yy=3.715e+13.*xx.^(-4.751);
plot(xx,yy,'linewidth',2,'linestyle','--')
xlim([100 600])
ylim([0 280])
title('distribution density')

%inset log-log scale
figure(21)
plot(xi,f*30000,'linewidth',2)
xi2=xi(1,30:100);
f2=f(1,30:100)*30000;
xx=200:600;yy=3.715e+13.*xx.^(-4.751);
hold on
plot(xx,yy,'linewidth',2,'linestyle','--')
xlim([200 500])
ylim([1,280])
set(gca,'xscale','log')
set(gca,'yscale','log')
title('Distribution of degree vs power law of correlations? ')


%% fiugre S5
for ii=1:5
    valid_C1_temp=valid_C(:,(1+(ii-1)*2000):(ii*2000))';
    C_temp=corr(valid_C1_temp,valid_C1_temp);
    C_temp(isnan(C_temp))=0;
    deg_temp=sum(abs(C_temp));
    figure(23+ii)
   % histogram(deg_temp,10)
   s=1.3;
    t=deg_temp<400*s;
    scatter(centered_neuron_AP(t),centered_neuron_ML(t),10,'y')
    axis off
    hold on
    t=((deg_temp>=400*s)&(deg_temp<450*s));
    scatter(centered_neuron_AP(t),centered_neuron_ML(t),10,'b','fill')
    hold on
    t=((deg_temp>=450*s)&(deg_temp<500*s));
    scatter(centered_neuron_AP(t),centered_neuron_ML(t),20,'g','fill')
    hold on
    t=(deg_temp>=500*s);
    scatter(centered_neuron_AP(t),centered_neuron_ML(t),40,'r','fill')
   % set(gcf,'color','none');
   % set(gca,'color','none');
   % set(gcf,'InvertHardCopy','off');
    set(gca, 'YDir', 'reverse');
    set(gca, 'XDir', 'reverse');
   title('neural correlations with time')


end
% set(gcf,'color','none');
% set(gca,'color','none');
% set(gcf,'InvertHardCopy','off');

%% figure 3f
%spike train burst,random shuffle
valid_S0=valid_S;
valid_Scontrol=valid_S;

for ii=1:size(valid_S,1)
    idx = randperm(size(valid_S,2));
    valid_S0(ii,:)=valid_S(ii,:)>0;
    valid_Scontrol(ii,:)=valid_S(ii,idx)>0;
end
figure(29);yyaxis left;
histogram(sum(valid_S0),40,'EdgeColor','none','FaceColor','magenta'	)
hold on;histogram(sum(valid_Scontrol),10,'EdgeColor','none','FaceColor','cyan')
yyaxis right;
[f1,xi1] = ksdensity(sum(valid_S0));plot(xi1,f1);hold on;[f2,xi2] = ksdensity(sum(valid_Scontrol));plot(xi2,f2);
figure(30);[f1,xi1] = ksdensity(sum(valid_S0));plot(xi1,f1);hold on;[f2,xi2] = ksdensity(sum(valid_Scontrol));plot(xi2,f2);set(gca,'yscale','log');title('burst probability');xlim([0 250])

figure(31);plot(xi1,f1);hold on;plot(xi2,f2);set(gca,'xscale','log');set(gca,'yscale','log');title('burst probability');xlim([0 250])
figure(32);plot(xi1,f1);hold on;plot(xi2,f2);title('burst probability');xlim([0 250])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% figure 3f
%spike train burst, circular shuffle
valid_S0=valid_S;
valid_Scontrol=valid_S;

for ii=1:size(valid_S,1)
    idx = round((rand-0.5)*2*5540);
    valid_S0(ii,:)=valid_S(ii,:)>0;
    valid_Scontrol(ii,:)=circshift(valid_S0(ii,:),idx);
end
figure(34);yyaxis left;
histogram(sum(valid_S0),40,'EdgeColor','none','FaceColor','magenta'	)
hold on;histogram(sum(valid_Scontrol),10,'EdgeColor','none','FaceColor','cyan')
yyaxis right;
[f1,xi1] = ksdensity(sum(valid_S0));plot(xi1,f1);hold on;[f2,xi2] = ksdensity(sum(valid_Scontrol));plot(xi2,f2);
figure(35);[f1,xi1] = ksdensity(sum(valid_S0));plot(xi1,f1);hold on;[f2,xi2] = ksdensity(sum(valid_Scontrol));plot(xi2,f2);set(gca,'yscale','log');title('burst probability');xlim([0 250])

figure(36);plot(xi1,f1);hold on;plot(xi2,f2);set(gca,'xscale','log');set(gca,'yscale','log');title('burst probability');xlim([0 250])
figure(37);plot(xi1,f1);hold on;plot(xi2,f2);title('burst probability');xlim([0 250])




