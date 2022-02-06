clc
close all
load data
D = data(1:799,:);

% 整理
data = D(:,1:2);%[X_1; X_2; X_3];
label = D(:,3);%[label_1; label_2; label_3];

% 参数设置
c = 0.8; % trade-off parameter
g = 0.5; % kernel width

% 训练SVM模型
cmd = ['-s 0 -t 2 ', '-c ', num2str(c), ' -g ', num2str(g), ' -q'];
model = libsvmtrain(label, data, cmd);
[~, acc, ~] = libsvmpredict(label, data, model); 

% 生成网格点
d = 1;
[X1, X2] = meshgrid(min(data(:,1)):d:max(data(:,1)), min(data(:,2)):d:max(data(:,2)));
X_grid = [X1(:), X2(:)];
% 设定网格点标签（仅充当输入参数）
grid_label = ones(size(X_grid, 1), 1);
% 预测网格点标签
[pre_label, ~, ~] = libsvmpredict(grid_label, X_grid, model);

%%
% 绘制散点图
% 绘制散点图
figure
% set(gcf,'position',[300 150 420 360])
color_p = [150, 138, 191;12, 112, 104; 220, 94, 75]/255; % 数据点颜色
color_b = [218, 216, 232; 179, 226, 219; 244, 195, 171]/255; % 边界区域颜色
hold on
ax(1:3) = gscatter(X_grid (:,1), X_grid (:,2), pre_label, color_b);
legend('off')
axis tight

% 绘制原始数据图
ax(4:6) = gscatter(data(:,1), data(:,2), label);
set(ax(4), 'Marker','o', 'MarkerSize', 6, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(1,:));
set(ax(5), 'Marker','o', 'MarkerSize', 6, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(2,:));
set(ax(6), 'Marker','o', 'MarkerSize', 6, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(3,:));
legend('off')
set(gca, 'linewidth', 1.1)
title('Decision boundary')
axis tight