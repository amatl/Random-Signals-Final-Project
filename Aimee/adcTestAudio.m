watermark = audioread('audio1.wav');
watermarkLength = 1000;
watermarkScale = 0.05;
[watermarkedA, watermark] = applyAudioWatermark(A, Fs, watermarkLength,watermarkScale);
sound(real(double(watermarkedA)), Fs);
xlswrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Random-Signals-Final-Project\Audio\adcAttack\watermark.xls',watermark(:,3));