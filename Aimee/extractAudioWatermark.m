function [ extWatermark ] = extractAudioWatermark( Aorig,Acandidate,watermark )
%Aorig = fftshift(fft(Aorig));
%Acandidate = fftshift(fft(Acandidate));

Diff = real(log(Acandidate))-real(log(Aorig));
extWatermark = zeros(length(watermark),1);
for i = 1:length(watermark)
    extWatermark(i) = Diff(watermark(i,2));
end

end

