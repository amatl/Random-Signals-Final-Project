clc;
clear all;

%Import Image
image = imread('Image2.jpg');
subplot(1,3,1);
imshow(image);
title('Original Image');

%Create watermark
n =  length(image(1,:,1));%Let length of watermark be the # of rows
a = 1;%scaling parameter
x = randn(1,n);%Create random variable

%Apply watermark
image = rgb2ntsc(image);%convert color image to YIQ representation
image_f = dct2(image(:,:,1));%Extract Y (brightness) and convert to frequency domain
[v,ind] = max(image_f);%Extract highest spectral components of the image
v_new = v+a.*x;%apply simple watermark to highest specral components in each row
image_f_new = image_f;
for i = 1:n-1%insert new values into old frequency domain image
    image_f_new(i,ind(i)) = v_new(i);
end
image_new = image;
image_new(:,:,1) = idct2(image_f_new);%Perform inverse fourier transform
subplot(1,3,2);
imshow(ntsc2rgb(image_new))
title('Watermarked Image');

%Filter image
image_new_filtered = imguidedfilter(image_new);
subplot(1,3,3);
imshow(ntsc2rgb(image_new_filtered))
title('Filtered Watermarked Image');

%Extract watermark from filtered image Y value
image_new_filtered_f = dct2(image_new_filtered(:,:,1));
watermark = (image_new_filtered_f-image_f)./a;
x_watermark = max(watermark);
similarity = x_watermark*x'/sqrt(x_watermark*x_watermark')
%or we can use the correlation coefficient
corrcoef(x_watermark,x)

%References:
%DCT definition: http://fourier.eng.hmc.edu/e161/lectures/dct/node1.html