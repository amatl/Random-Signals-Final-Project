function [ watermarkedA, watermark ] = applyAudioWatermark( A, Fs, watermarkLength, watermarkScale )
%Get the frequency content of the audio
%nfft = 1024;%set fft length
nfft = length(A);
df = linspace(0,Fs,nfft);
A_fft = fftshift(fft(A,nfft));
figure(1);
plot(df,abs(A_fft))
%Generate watermark: output is an array where column 1: spectral components
%from high to low, column 2: corresponding array index, column 3: random
%gaussian value
watermark = generateAudioWatermark(A_fft,watermarkLength);

%Apply watermark
A_fft_new = A_fft;
for val = watermark'
    A_fft_new(val(2)) = A_fft(val(2)).*exp(watermarkScale*val(3));
end
figure(2);
plot(df,abs(A_fft_new));
%Reconstruct Audio
watermarkedA = ifft(ifftshift(A_fft));
end

