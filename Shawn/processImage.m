% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Convert to YIQ
yiq = rgb2ntsc(I);
yData = yiq(:,:,1);
% Calculate DCT
J = dct2(yData);
% Manipulate value for demonstration
J(20,10) = J(20,10)*200;
% Display DCT
figure(2);
imagesc(log(abs(J)));
colorbar;
% Reconstruct
yiq2 = yiq;
yiq(:,:,1)=idct2(J);
% Display modified
figure(3);
imagesc(ntsc2rgb(yiq));