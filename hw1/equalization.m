% dividing the intensity values by 3
I = readraw('raw/sample2.raw');
I_div_3 = uint8(I/3);
I_div_3_m = zeros(256,256,3,'uint8');
I_div_3_m(:,:,1) = I_div_3(:,:);
I_div_3_m(:,:,2) = I_div_3(:,:);
I_div_3_m(:,:,3) = I_div_3(:,:);
figure('name','dividing the intensity values by 3');
imshow(I_div_3_m);
writeraw(I_div_3,'D.raw');

% plot histogram of I_2 and D
hist_list_I = PlotHistogram('histogram of I_2',I);
hist_list_D = PlotHistogram('histogram of D',I_div_3);

% compute CDF
cumulative_list = zeros(1,256);
size = 256*256;
for i=1:256
    if i == 1
        cumulative_list(i) = hist_list_D(i)/size;
    else
        cumulative_list(i) = cumulative_list(i-1) + hist_list_D(i)/size;
    end
end

% figure;
% plot(cumulative_list);


% global histogram equalization
map_list = zeros(1,255);
for i = 1:255
    map_list(i) = uint8(255 * cumulative_list(i));
end

I_equal = zeros(256,256);
for i = 1:256
    for j = 1:256
        I_equal(i,j)=map_list(I_div_3(i,j)+1);
    end
end
I_equal_m = zeros(256,256,3,'uint8');
I_equal_m(:,:,1) = I_equal(:,:);
I_equal_m(:,:,2) = I_equal(:,:);
I_equal_m(:,:,3) = I_equal(:,:);

figure('name','global histogram equalization');
imshow(I_equal_m);
writeraw(I_equal,'H.raw');


% local histogram equalization
I_local_equal = I;
blocksize = 15;
hsize = floor(blocksize/2);
area = blocksize * blocksize;
for i=hsize+1:255-hsize
    for j=hsize+1:256-hsize
        rank = 0;
        for x=i-hsize:i+hsize
            for y=j-hsize:j+hsize
                if I_div_3(i,j)>I_div_3(x,y)
                    rank = rank+1;
                end
            end
        end
        I_local_equal(i,j) = uint8(rank*255/area);
    end
end

I_local_equal_m = zeros(256,256,3,'uint8');
I_local_equal_m(:,:,1) = I_local_equal(:,:);
I_local_equal_m(:,:,2) = I_local_equal(:,:);
I_local_equal_m(:,:,3) = I_local_equal(:,:);

figure('name','local histogram equalization');
imshow(I_local_equal_m);
writeraw(I_local_equal,'L.raw');

% histogram of H
hist_list = PlotHistogram('histogram of H',I_equal);

% histogram of L
hist_list = PlotHistogram('histogram of L',I_local_equal);



% log transform

c=120; % changable parameters
I_log_transform = uint8(c.*log10(double(I_div_3)+1));

I_log_transform_m = zeros(256,256,3,'uint8');
I_log_transform_m(:,:,1) = I_log_transform;
I_log_transform_m(:,:,2) = I_log_transform;
I_log_transform_m(:,:,3) = I_log_transform;

figure('name','log transform');
imshow(I_log_transform_m);
% writeraw(I_log_transform,'log_transform.raw');

% inverse log transform
c=8; % changable parameters
I_inv_log_transform = uint8((exp(double(I_div_3)) .^ (1/c)) -1) ;

I_inv_log_transform_m = zeros(256,256,3,'uint8');
I_inv_log_transform_m(:,:,1) = I_inv_log_transform;
I_inv_log_transform_m(:,:,2) = I_inv_log_transform;
I_inv_log_transform_m(:,:,3) = I_inv_log_transform;

figure('name','inverse log transform');
imshow(I_inv_log_transform_m);
% writeraw(I_inv_log_transform,'inverse_log_transform.raw');

% power-law transform
c=3; % changable parameters
gamma = 1.1; % changable parameters
I_power_transform = uint8(c*(double(I_div_3)).^gamma);

I_power_transform_m = zeros(256,256,3,'uint8');
I_power_transform_m(:,:,1) = I_power_transform;
I_power_transform_m(:,:,2) = I_power_transform;
I_power_transform_m(:,:,3) = I_power_transform;

figure('name','power-law transform');
imshow(I_power_transform_m);
% writeraw(I_power_transform,'powerlaw_transform.raw');