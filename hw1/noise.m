% Gaussian Noise Generator
I = readraw('raw/sample3.raw');

c = 20;
array_gaussian_noise=floor(randn(256,256)*c);

I_gaussian_noise = double(I)+array_gaussian_noise;

I_gaussian_noise_m = zeros(256,256,3,'uint8');
I_gaussian_noise_m(:,:,1) = I_gaussian_noise;
I_gaussian_noise_m(:,:,2) = I_gaussian_noise;
I_gaussian_noise_m(:,:,3) = I_gaussian_noise;

figure('name','G_1:gaussian noise image');
imshow(I_gaussian_noise_m);
writeraw(I_gaussian_noise,'G_1.raw');

% salt-and-pepper noise generator
array_salt_noise = rand(256,256);
threshold = 0.002;
I_salt_noise = zeros(256,256,'uint8');
for i=1:256
    for j=1:256
        if(array_salt_noise(i,j) < threshold)
            I_salt_noise(i,j) = 0;
        elseif(array_salt_noise(i,j) > 1-threshold)
            I_salt_noise(i,j) = 255;
        else
            I_salt_noise(i,j) = I(i,j);
        end
    end
end

I_salt_noise_m = zeros(256,256,3,'uint8');
I_salt_noise_m(:,:,1) = I_salt_noise;
I_salt_noise_m(:,:,2) = I_salt_noise;
I_salt_noise_m(:,:,3) = I_salt_noise;

figure('name','S_1:salt-and-pepper noise');
imshow(I_salt_noise_m);
writeraw(I_salt_noise,'S_1.raw');


% Remove gaussian Noise
I_remove_gaussian_noise = zeros(256,256,'uint8');
frame = 3;
hsize = floor(frame/2);
weight = [1,1,1;1,1,1;1,1,1]*(1/9);


augmented_I_noise = [I_gaussian_noise(1,:);I_gaussian_noise;I_gaussian_noise(255,:)]; % copy the edge block
augmented_I_noise = cat(2,augmented_I_noise(:,1),augmented_I_noise);
augmented_I_noise = cat(2,augmented_I_noise,augmented_I_noise(:,257));

for i=2:257
    for j=2:257
        value = 0;
        for x=i-hsize:i+hsize
            for y=j-hsize:j+hsize
                value = value + weight(x-i+2,y-j+2)*augmented_I_noise(x,y);
            end
        end
        I_remove_gaussian_noise(i-1,j-1) = value;
    end
end

I_remove_gaussian_noise_m = zeros(256,256,3,'uint8');
I_remove_gaussian_noise_m(:,:,1) = I_remove_gaussian_noise;
I_remove_gaussian_noise_m(:,:,2) = I_remove_gaussian_noise;
I_remove_gaussian_noise_m(:,:,3) = I_remove_gaussian_noise;

figure('name','R_G:low-pass filtering');
imshow(I_remove_gaussian_noise_m);
writeraw(I_remove_gaussian_noise,'R_G.raw');


% Remove salt-and-pepper noise
I_remove_salt_noise = zeros(256,256,'uint8');

blocksize=3;
hsize = floor(blocksize/2);

for i=hsize+1:255-hsize
    for j=hsize+1:256-hsize
        rank = 0;
        m = median(I_salt_noise(i-hsize:i+hsize,j-hsize:j+hsize));
        I_remove_salt_noise(i,j) = m(1);
    end
end

I_remove_salt_noise_m = zeros(256,256,3,'uint8');
I_remove_salt_noise_m(:,:,1) = I_remove_salt_noise;
I_remove_salt_noise_m(:,:,2) = I_remove_salt_noise;
I_remove_salt_noise_m(:,:,3) = I_remove_salt_noise;
figure('name','R_S:non-linear filtering');
imshow(I_remove_salt_noise_m);
writeraw(I_remove_salt_noise,'R_S.raw');


% PSNR
diff_G = I-double(I_remove_gaussian_noise);
MSE_G = sum((diff_G(:)).^2)/(256*256);
PSNR_G = 10*log10(255.^2/MSE_G);
disp([' PSNR values of R_G is ' num2str(PSNR_G) ]);

diff_S = I-double(I_remove_salt_noise);
MSE_S = sum((diff_S(:)).^2)/(256*256);
PSNR_S = 10*log10(255.^2/MSE_S);
disp([' PSNR values of R_S is ' num2str(PSNR_S) ]);


% remove wrinkles
I4 = readraw('raw/sample4.raw');
I_remove_wrinkles = zeros(256,256,'uint8');

% non-linear filtering
blocksize=5;
hsize = floor(blocksize/2);

for i=hsize+1:255-hsize
    for j=hsize+1:256-hsize
        rank = 0;
        m = median(I4(i-hsize:i+hsize,j-hsize:j+hsize));
        I_remove_wrinkles(i,j) = m(1);
    end
end

I_remove_wrinkles_m = zeros(256,256,3,'uint8');
I_remove_wrinkles_m(:,:,1) = I_remove_wrinkles;
I_remove_wrinkles_m(:,:,2) = I_remove_wrinkles;
I_remove_wrinkles_m(:,:,3) = I_remove_wrinkles;
figure('name','remove wrinkles');
imshow(I_remove_wrinkles_m);
writeraw(I_remove_wrinkles,'remove_wrinkles.raw');