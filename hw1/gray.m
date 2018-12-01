% convert to gray-level
% Compute the average of R,G,B
I = readrawRGB('raw/sample1.raw');

gray_m = zeros(256,256,3,'uint8');
gray_1 = zeros(256,256,'uint8');
for i=1:256
    for j=1:256
        gray_1(i,j) = sum(I(i,j,:))/3;
    end
end
gray_m(:,:,1) = gray_1;
gray_m(:,:,2) = gray_1;
gray_m(:,:,3) = gray_1;

figure;
imshow(gray_m);
writeraw(gray_1,'gray_level.raw');

% Main diagonal flipping.
flip = zeros(256,256,'uint8');

for i=1:256
    for j=1:256
        flip(i,j) = gray_1(j,i);
    end
end

flip_m = zeros(256,256,3,'uint8');
flip_m(:,:,1) = flip;
flip_m(:,:,2) = flip;
flip_m(:,:,3) = flip;

figure;
imshow(flip_m);
writeraw(flip,'B.raw');