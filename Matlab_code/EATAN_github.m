clear all;
clc;
close all;

Fs=250; % method 1: increase frequency sample rate
ts=500; % IQ_5s/FFT_50s 50
t=1/Fs:1/Fs:ts;
Vi=0; %0.5
Vq=0; %-0.7
Ar=1;
Ae=1;
delta_pha=0;%pi/12
c = 3e8;
fc = 24e9;
lambda =c/fc; 

% condition-1 not meet
% Ax = 0.5;
% fx1 = 1;
% phi0=-2*pi*fx1/Fs+pi/2;

% condition-2 not meet
Ax = 10;
fx1 = 1;
phi0=0;


XhXr = Ax*cos(2*pi*fx1*t+phi0);
phase=4*pi/lambda*(XhXr);

% IQ imbalance signal 
Bi=Vi+Ar*cos(phase);
Bq= Vq+Ar*Ae*sin(phase+delta_pha);


k = 0;
while true
    k = k+1;
    if(max(4*pi/lambda*diff(XhXr, k)) < pi)
        break;
    end
end

if k < 2
    k = 2;
end


%% EATAN-A1 demodulation method
phase_EATAN_A1 = EATAN_A1(Bq, Bi);
phase_EATAN_A1 = phase_EATAN_A1.';


%% EATAN-A2 demodulation method
phase_EATAN_A2 = EATAN_A2(Bq, Bi, k, Fs, ts);


ts_show = 3;

figure(1)
hold on;plot(t(1:ts_show*Fs),phase(1:ts_show*Fs),'color','#364F6B','linestyle','-', 'marker', '+', 'markersize', 6, 'markerindices',1:30:length(t(1:ts_show*Fs)));
hold on;plot(t(1:ts_show*Fs),phase_EATAN_A1(1:ts_show*Fs),'color','#E83A14','linestyle','-.', 'marker', '*', 'markersize', 4, 'markerindices',1:37:length(t(1:ts_show*Fs)));
hold on;plot(t(1:ts_show*Fs),phase_EATAN_A2(1:ts_show*Fs),'color','b','linestyle','-.', 'marker', 'd', 'markersize', 4, 'markerindices',1:33:length(t(1:ts_show*Fs)));
legend('Baseline','EATAN-A1','EATAN-A2');

figure(2)
d_phase = diff(phase);
d_phase_EATAN_A2 = diff(phase_EATAN_A2);
d_phase_EATAN_A1 = diff(phase_EATAN_A1);
hold on;plot(t(2:ts_show*Fs),d_phase(1:ts_show*Fs-1),'color','#364F6B','linestyle','-', 'marker', '+', 'markersize', 4, 'markerindices',1:10:length(t(2:ts_show*Fs)));
hold on;plot(t(2:ts_show*Fs),d_phase_EATAN_A1(1:ts_show*Fs-1),'color','#E83A14','linestyle','-.', 'marker', '*', 'markersize', 4, 'markerindices',1:13:length(t(2:ts_show*Fs)));
hold on;plot(t(2:ts_show*Fs),d_phase_EATAN_A2(1:ts_show*Fs-1),'color','b','linestyle','-.', 'marker', 'd', 'markersize', 3, 'markerindices',1:15:length(t(2:ts_show*Fs)));
legend('Baseline','EATAN-A1','EATAN-A2');









