function filteredImg=textureFilter(I,filter1,filter2)

filter = filter1.'*filter2;
filteredImg = conv2(I, filter, 'same');

filtered1_m = zeros(512,512,3,'uint8');
filtered1_m(:,:,1) = filteredImg;
filtered1_m(:,:,2) = filteredImg;
filtered1_m(:,:,3) = filteredImg;
figure;
imshow(filtered1_m);
end