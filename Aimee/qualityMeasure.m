[A,Fs] = audioread('audio1.wav');
dt = 1/Fs;
T = dt*(length(A)-1);
t = 0:dt:T;

%Find Highest spectral points
watermarkLength = 1000;
watermarkScale = 0.05;
[watermarkedA, watermark] = applyAudioWatermark(A, Fs, watermarkLength,watermarkScale);
%sound(real(double(watermarkedA)), Fs);
%audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn0compress.wav',watermarkedA,Fs);

%%%%%%Lossy Compression Quality Measurement%%%%%%%
comparisonTimes = 20;

figure(1);
similarity = ones(1,comparisonTimes);
randSimilarity = ones(1,comparisonTimes);
subplot(1,4,2);
plot(t,watermarkedA);
title('Watermarked Image, n = 0');
xlabel('Time (s)');
ylabel('Amplitude');
nfft = length(A);
df = linspace(0,Fs,nfft);
A_fft = fftshift(fft(A,nfft));
randWatermark = generateAudioWatermark(A_fft,watermarkLength);
randSimilarity(1)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
similarity(1) = watermark(:,3)'*watermark(:,3)/sqrt(watermark(:,3)'*watermark(:,3));
newFs = Fs;
for i = 2:comparisonTimes 
    %Compress watermarked Audio
      s = length(watermarkedA);
      watermarkedA = resample(watermarkedA,1,2);
    
    %Extract watermark
    r = resample(watermarkedA,length(A),length(watermarkedA));
    if(size(r,1)==1)
        r = r.';
    end
    Diff = (real(fftshift(fft(r)))-real(fftshift(fft(A))))/watermarkScale;
    extWatermark = zeros(length(watermark),1);
    for l = 1:length(watermark)
        x = watermark(l,2);
        extWatermark(l) = Diff(watermark(l,2));
    end
    
    if(i == 2)
       % audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn2compress.wav',r,Fs);
    elseif (i == 4)
        subplot(1,4,3);
        plot(t,r);
        title('Watermarked Image, n = 4');
        xlabel('Time (s)');
        ylabel('Amplitude');
        %audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn4compress.wav',r,Fs);
    elseif (i == 10)
         subplot(1,4,4);
         plot(t,r);
         title('Watermarked Image, n = 10');
         xlabel('Time (s)');
         ylabel('Amplitude');
    end
    
    similarity(i) = extWatermark'*watermark(:,3)/sqrt(extWatermark'*extWatermark);
    randWatermark = generateAudioWatermark(A_fft,watermarkLength);
    randSimilarity(i)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
end
n = 1:comparisonTimes;
subplot(1,4,1);
plot(n,similarity,'Color','b')
hold on;
plot(n,randSimilarity,'Color','g');
xlabel('Number of Lossy Compressions');
ylabel('Similarity');
legend('Applied Watermark','Random Watermarks');
title('Repeated Compression of Watermarked Image');

%%%%%%Filtering Quality Measurement%%%%%%%


watermarkLength = 1000;
watermarkScale = 0.05;
[watermarkedA, watermark] = applyAudioWatermark(A, Fs, watermarkLength,watermarkScale);
%audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn0filter.wav',watermarkedA,Fs);


similarity = ones(1,comparisonTimes);
randSimilarity = ones(1,comparisonTimes);

figure(2);

subplot(1,4,2);
A_fft = fftshift(fft(watermarkedA,length(watermarkedA)));
plot(df./10^3,abs(A_fft));
title('Frequency Domain Plot of Watermarked Audio');
xlabel('Frequency (kHz)');
ylabel('Amplitude');

randWatermark = generateAudioWatermark(A_fft,watermarkLength);
randSimilarity(1)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
similarity(1) = watermark(:,3)'*watermark(:,3)/sqrt(watermark(:,3)'*watermark(:,3));
%Normalized Cutoff Frequency
beginFreq = linspace(40/Fs,1/2,comparisonTimes-1);%Want cutoff frequency to move from 20 Hz to Fs/2 to be within nyquist
for i = 2:comparisonTimes 
    %Filter watermarked Audio
    [b,a] = butter(5, beginFreq(i-1), 'high');
    watermarkedA = filter(b,a,watermarkedA);

    %Extract watermark
    Diff = (real(fftshift(fft(watermarkedA)))-real(fftshift(fft(A))))/watermarkScale;
    extWatermark = zeros(length(watermark),1);
    for l = 1:length(watermark)
        x = watermark(l,2);
        extWatermark(l) = Diff(watermark(l,2));
    end
    if (i ==2)

       
        A_fft = fftshift(fft(watermarkedA,length(watermarkedA)));
        plot(df./10^3,abs(A_fft));
        title('Frequency Domain Plot of Watermarked Audio Filter');
        xlabel('Frequency (kHz)');
        ylabel('Amplitude');
        
        %audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn2filter.wav',watermarkedA,Fs);
    elseif(i == 4)
       
        subplot(1,4,3);
        A_fft = fftshift(fft(watermarkedA,length(watermarkedA)));
        plot(df./10^3,abs(A_fft));
        title('Frequency Domain Plot of Watermarked Audio, n = 4');
        xlabel('Frequency (kHz)');
        ylabel('Amplitude');
        
       % audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn4filter.wav',watermarkedA,Fs);
    elseif (i == 10)
       %{
        [h,w] = freqz(b,a);
        plot(w./(2*pi).*Fs./10^3,10*log10(abs(h./max(h))));
        title('Frequency Response for n = 10');
        ylabel('Magnitude (dB)');
        xlabel('Frequency (kHz)');
        
        %}
         subplot(1,4,4);
        A_fft = fftshift(fft(watermarkedA,length(watermarkedA)));
        plot(df./10^3,abs(A_fft));
        title('Frequency Domain Plot of Watermarked Audio, n = 10');
        xlabel('Frequency (kHz)');
        ylabel('Amplitude');
        
        %audiowrite('C:\Users\Aimee\Documents\Fall 2015\Random Signals\Final Project\Presentation\watermarkedAn10filter.wav',watermarkedA,Fs);
    end
    
    similarity(i) = extWatermark'*watermark(:,3)/sqrt(extWatermark'*extWatermark);
    randWatermark = generateAudioWatermark(A_fft,watermarkLength);
    randSimilarity(i)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
end
n = 1:comparisonTimes;

subplot(1,4,1);
plot(n,similarity,'Color','b')
hold on;
plot(n,randSimilarity,'Color','g');
xlabel('Number of times filtered');
ylabel('Similarity');
legend('Applied Watermark','Random Watermarks');
title('Repeated Filtering of Watermarked Image');


