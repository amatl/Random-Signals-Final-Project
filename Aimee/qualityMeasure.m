[A,Fs] = audioread('audio1.wav');
dt = 1/Fs;
T = dt*(length(A)-1);
t = 0:dt:T;

%Find Highest spectral points
watermarkLength = 1000;
watermarkScale = 0.05;
[watermarkedA, watermark] = applyAudioWatermark(A, Fs, watermarkLength,watermarkScale);
%sound(real(double(watermarkedA)), Fs);

%%%%%%Lossy Compression Quality Measurement%%%%%%%
compressionTimes = 20;

similarity = ones(1,compressionTimes);
randSimilarity = ones(1,compressionTimes);
subplot(1,4,2);
plot(t,watermarkedA);
title('Watermarked Image, n = 0');
nfft = length(A);
df = linspace(0,Fs,nfft);
A_fft = fftshift(fft(A,nfft));
randWatermark = generateAudioWatermark(A_fft,watermarkLength);
randSimilarity(1)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
similarity(1) = watermark(:,3)'*watermark(:,3)/sqrt(watermark(:,3)'*watermark(:,3));
for i = 2:compressionTimes 
    %Compress watermarked Audio
      s = length(watermarkedA);
      watermarkedA = resample(watermarkedA,1,2);

    %Extract watermark
    r = resample(watermarkedA,length(A),length(watermarkedA));
    if(size(r,1)==1)
        r = r.';
    end
    Diff = (real(ifftshift(fft(r)))-real(ifftshift(fft(A))))/watermarkScale;
    extWatermark = zeros(length(watermark),1);
    for l = 1:length(watermark)
        x = watermark(l,2);
        extWatermark(l) = Diff(watermark(l,2));
    end
    
    if(i == 4)
        subplot(1,4,3);
        plot(t,r);
        title('Watermarked Image, n = 4');
    elseif (i == 10)
         subplot(1,4,4);
         plot(t,r);
         title('Watermarked Image, n = 10');
    end
    
    similarity(i) = extWatermark'*watermark(:,3)/sqrt(extWatermark'*extWatermark);
    randWatermark = generateAudioWatermark(A_fft,watermarkLength);
    randSimilarity(i)= randWatermark(:,3)'*watermark(:,3)/sqrt(randWatermark(:,3)'*randWatermark(:,3));
end
n = 1:compressionTimes;
subplot(1,4,1);
plot(n,similarity,'Color','b')
hold on;
plot(n,randSimilarity,'Color','g');
xlabel('Number of Lossy Compressions');
ylabel('Similarity');
legend('Applied Watermark','Random Watermarks');