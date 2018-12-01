%% .Segment the image
I = readraw('raw/sample2.raw');

L5 = [1 4 6 4 1];
E5 = [-1 -2 0 2 1];
S5 = [-1 0 2 0 -1];
R5 = [1 -4 6 -4 1];

microstructureArray = zeros(9,512,512);
microstructureArray(1,:,:) = textureFilter(I,L5,E5);
microstructureArray(2,:,:) = textureFilter(I,L5,R5);
microstructureArray(3,:,:) = textureFilter(I,E5,S5);
microstructureArray(4,:,:) = textureFilter(I,S5,S5);
microstructureArray(5,:,:) = textureFilter(I,R5,R5);
microstructureArray(6,:,:) = textureFilter(I,L5,S5);
microstructureArray(7,:,:) = textureFilter(I,E5,E5);
microstructureArray(8,:,:) = textureFilter(I,E5,R5);
microstructureArray(9,:,:) = textureFilter(I,S5,R5);

% energy computation
LocalFeatures = zeros(512,512);
rangeSize = 15; % windowSize = 13

for j=rangeSize+1:512-rangeSize
    for k=rangeSize+1:512-rangeSize
        list = reshape(microstructureArray(4,j-rangeSize:j+rangeSize,k-rangeSize:k+rangeSize),[1,(2*rangeSize+1).^2]);
        meanValue = var(list);
        LocalFeatures(j,k) = meanValue;
    end
end

% classification
classify = zeros(512,512,'uint8');
features = zeros(262144,1);
idx = 1;
for j=1:512
    for k=1:512
        features(idx,:) = LocalFeatures(j,k);
        idx = idx + 1;
    end
end

idxs = kmeans(features,2);
idx_m = reshape(idxs,[512,512]).';

for i=1:512
    for j=1:512
        if idx_m(i,j)==1
            classify(i,j) = 0;
        elseif idx_m(i,j)==2
            classify(i,j) = 255;
        else
            classify(i,j) = 128;
        end
    end
end

figure;
imshow(classify);


% classify 2
LocalFeatures2 = zeros(9,512,512);
rangeSize = 6; % windowSize = 13
filter = [1,1,1;1,1,1;1,1,1];

for i=1:9
    LocalFeatures2(i,:,:) = conv2(reshape(microstructureArray(i,:,:),[512,512]), filter, 'same').^2;
end

% classification
classify2 = zeros(512,512,'uint8');
features2 = zeros(262144,9);
idx = 1;
for j=1:512
    for k=1:512
        features2(idx,:) = LocalFeatures2(:,j,k);
        idx = idx + 1;
    end
end

for i=1:512
    for j=1:512
        distance1 = sqrt(sum((LocalFeatures2(:,i,j) - LocalFeatures2(:,100,101)) .^ 2));
        distance2 = sqrt(sum((LocalFeatures2(:,i,j) - LocalFeatures2(:,264,367)) .^ 2));
        distance3 = sqrt(sum((LocalFeatures2(:,i,j) - LocalFeatures2(:,450,382)) .^ 2));
        if min([distance1,distance2,distance3]) == distance1
            classify2(i,j) = 0;
        elseif min([distance1,distance2,distance3]) == distance2
            classify2(i,j) = 255;
        else
            classify2(i,j) = 128;
        end
    end
end

for iter=1:10
    for i=2:511
        for j=2:511
            A = 0;
            for x=i-1:i+1
                for y=j-1:j+1
                    if classify2(x,y) ~= 0
                        A = A+1;
                    end
                end
            end
            if A >=3 || classify2(i,j) ~= 0
                classify2(i,j) = 255;
            end
        end
    end
end
figure;
imshow(classify2);

% seperate 
classify3 = zeros(512,512);
for i=1:512
    for j=1:512
        if classify(i,j) == 0
            classify3(i,j) = 0.5;
        elseif classify2(i,j) == 0
            classify3(i,j) = 0;
        else
            classify3(i,j) = 1;
        end
    end
end
figure;
imshow(classify3)
writeraw(classify3,'K.raw');