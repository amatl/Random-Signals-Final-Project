close all;
clear all;
clc;

%Import audio file (http://www.thesoundarchive.com/starwars/swvader01.wav)
[A,Fs] = audioread('audio1.wav');
dt = 1/Fs;
T = dt*(length(A)-1);
t = 0:dt:T;
nfft = length(A);
%{
%Plot the amplitude of the audio vs time
figure(1);
plot(t,A);
title('Time Domain Audio Plot')
xlabel('Time (s)');
ylabel('Amplitude');
%}
%sound(A,Fs)
%{
%Plot the frequency content of the audio
nfft = 1024;%set fft length
df = linspace(0,Fs,nfft);
A_fft = fftshift(fft(A,nfft));
plot(df./10^3,abs(A_fft));
title('Frequency Domain Audio Plot');
xlabel('Frequency (kHz)');
ylabel('Amplitude');
%}
%Find Highest spectral points
watermarkLength = 1000;
watermarkScale = 0.05;
%%%%%%%%%%
[watermarkedA, watermark] = applyAudioWatermark(A, Fs, watermarkLength,watermarkScale);

%figure(2);
%plot(t,watermarkedA)
sound(real(double(watermarkedA)), Fs);

%Extract watermark
%extWatermark = extractAudioWatermark(A,watermarkedA,watermark);
Diff = (real(ifftshift(fft(watermarkedA)))-real(ifftshift(fft(A))))/watermarkScale;
extWatermark = zeros(length(watermark),1);
for i = 1:length(watermark)
    x = watermark(i,2);
    extWatermark(i) = Diff(watermark(i,2));
end

fitnessChecks = 1000;
fitnessPlot = zeros(fitnessChecks,1);
randWatermark = watermark(:,3);
for i=1:fitnessChecks
    if i == 100
        randWatermark = watermark(:,3);
    else
        randWatermark = randn(length(watermark),1);
    end
    fitnessPlot(i) = extWatermark'*randWatermark/sqrt(extWatermark'*extWatermark);
end
figure(4);
plot(fitnessPlot);