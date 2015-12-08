function [ watermark ] = generateAudioWatermark( A_fft, length1 )
%Create array that contains absolute value of A_fft with corresponding
%index
temp = zeros(length(A_fft),2);
for i = 1:length(A_fft)
    if i~=1
        value = abs(A_fft(i));
        temp(i,:) = [value,i];
    end
end
points = sortrows(temp,-1);%Descending sort
points = points(1:length1,:);

watermark = [points randn(length1,1)];
end

