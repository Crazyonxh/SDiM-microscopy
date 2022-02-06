% 生成时间序列
fs = 40000;      % [Hz] 信号采样频率
T = 0.5;          % [s] 信号长度 
x = 0:1/fs:T;   % [s] 时间序列
 
% 生成信号序列
f = 1000;        % [Hz] 信号频率
y = 1*sin(2*pi*f*x);
 
% 输出音频文件
fname = '1KHz.wav';        % 设定文件名称 注意格式
audiowrite(fname,y,fs);     % 输出文件
