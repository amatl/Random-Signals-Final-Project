% Warning: this takes a while to run, because it needs to write and read
%  1000 jpeg images.

watermarkLength = 1000;

% Import image
I = imread('../RawImages/Lenna.png');
figure(1);
jpegPlot = zeros(100,10);

% Display original image
% subplot(2,2,2);
% imagesc(I);
% title('Original Image');
% Iterate through a range of watermark scales
for i = 1:10
    watermarkScale = i*0.01
    % Generate and apply watermark
    [watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
%     if i == 1
%         % Display least watermarked image
%         subplot(2,2,3);
%         imagesc(watermarkedI);
%         title('Smallest tested watermark (0.01)');
%     elseif i == 10
%         % Display most watermarked image
%         subplot(2,2,4);
%         imagesc(watermarkedI);
%         title('Largest tested watermark (0.1)');
%     end
    % Check for the watermark in various levels of compressed jpeg
    for quality=1:100
        imwrite(watermarkedI,'tmp.jpg','Quality',quality);
        jpegWatermarkedI = imread('tmp.jpg');
        extWatermark = extractWatermark(I,jpegWatermarkedI,watermark);
        jpegPlot(quality,i) = checkWatermark(extWatermark,watermark);
    end
end
% Display final plot
subplot(1,1,1);
imagesc(jpegPlot');
colorbar
title('Watermark integrity versus watermark size and Jpeg quality');
xlabel('Jpeg quality (lower means more compression)');
ylabel('Watermark power (x100)');
figure(2)
quality = 10;
imwrite(watermarkedI,'tmp.jpg','Quality',quality);
jpegWatermarkedI = imread('tmp.jpg');
imagesc(jpegWatermarkedI);
figure(3);
imagesc(getYComponent(watermarkedI)-getYComponent(jpegWatermarkedI));
colorbar;
figure(4);
imagesc(dct2(getYComponent(watermarkedI)))
figure(5);
imagesc(dct2(getYComponent(jpegWatermarkedI)))
