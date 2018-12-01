function edgemap = SecondEdgeDetection(I,T,sigma)

[h,w] = size(I);

% LoG
secondOrderG = zeros(h,w);
n=ceil(sigma*3)*2+1;
m=ceil(sigma*3);
logMask = zeros(n,n);
for i=1:n
    for j=1:n
        idx_I = abs(i-m-1);
        idx_J = abs(j-m-1);
        logMask(i,j) = exp(-((idx_I^2)+(idx_J^2))/(2*(sigma^2)));
    end
end
logMask = logMask/sum(logMask(:));

%Convolution of image by Gaussian Coefficient
I_low_pass=conv2(I, logMask, 'same');

I_low_pass_m = zeros(h,w,3,'uint8');
I_low_pass_m(:,:,1) = I_low_pass;
I_low_pass_m(:,:,2) = I_low_pass;
I_low_pass_m(:,:,3) = I_low_pass;
%imshow(I_low_pass_m);

I_zero_crossing = zeros(h,w);
for i=1:h
    for j=1:w
        if abs(I_low_pass(i,j)) <= T
            I_zero_crossing(i,j) = 0;
        else
            I_zero_crossing(i,j) = I_low_pass(i,j);
        end
    end
end
        
secondOrderEdge = zeros(h,w);
for i=2:h-1
    for j=2:w-1
        if I_zero_crossing(i,j) == 0
            if sign(I_zero_crossing(i-1,j-1)) ~= sign(I_zero_crossing(i+1,j+1))
                secondOrderEdge(i,j) = 255;
            elseif sign(I_zero_crossing(i+1,j)) ~= sign(I_zero_crossing(i-1,j))
                secondOrderEdge(i,j) = 255;
            elseif sign(I_zero_crossing(i+1,j-1)) ~= sign(I_zero_crossing(i-1,j+1))
                secondOrderEdge(i,j) = 255;
            elseif sign(I_zero_crossing(i,j-1)) ~= sign(I_zero_crossing(i,j+1))
                secondOrderEdge(i,j) = 255;
            else
                secondOrderEdge(i,j) = 0;
            end
        end
    end
end

figure('name','second Order Edge');
imshow(secondOrderEdge);

edgemap = secondOrderEdge;