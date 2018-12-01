function edgemap = CannyEdgeDetection(I,T_H,T_L)

[h,w] = size(I);

I_noise = zeros(h,w);
frame = 5;
hsize = floor(frame/2);
weight = [2,4,5,4,2;4,9,12,9,4;5,12,15,12,5;4,9,12,9,4;2,4,5,4,2]*(1/159.);

for i=0:h-1
    for j=0:w-1
        value = 0;
        for x=i-hsize:i+hsize
            for y=j-hsize:j+hsize
                if (x<0) || (y<0)
                    newX = abs(x);
                    newY = abs(y);
                else
                    newX = x;
                    newY = y;
                end
                if (x>h-1) && (y<=w-1)
                    newX = (2*h-2)-newX;
                elseif (y>w-1) && (x<=h-1)
                    newY = (2*w-2)-newY;
                elseif (y>w-1) && (x>h-1)
                    newX = (2*h-2)-newX;
                    newY = (2*w-2)-newY;
                end
                value = value + weight(x-i+3,y-j+3)*I(newX+1,newY+1);
            end
        end
        I_noise(i+1,j+1) = value;
    end
end

CannyNoise = zeros(h,w,3,'uint8');
CannyNoise(:,:,1) = I_noise;
CannyNoise(:,:,2) = I_noise;
CannyNoise(:,:,3) = I_noise;
%figure;
%imshow(CannyNoise);

% step 2: compute gradient magnitude and orientation
CannyGR = zeros(h,w);
CannyGC = zeros(h,w);
frame = 3;
hsize = floor(frame/2);
weightR = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
weightC = [1, 2, 1; 0, 0, 0; -1, -2, -1];

for i=0:h-1
    for j=0:w-1
        valueR = 0;
        valueC = 0;
        for x=i-hsize:i+hsize
            for y=j-hsize:j+hsize
                if (x<0) || (y<0)
                    newX = abs(x);
                    newY = abs(y);
                else
                    newX = x;
                    newY = y;
                end
                if (x>h-1) && (y<=w-1)
                    newX = (2*h-2)-newX;
                elseif (y>w-1) && (x<=h-1)
                    newY = (2*w-2)-newY;
                elseif (y>w-1) && (x>h-1)
                    newX = (2*h-2)-newX;
                    newY = (2*w-2)-newY;
                end
                valueR = valueR + weightR(x-i+2,y-j+2)*I_noise(newX+1,newY+1);
                valueC = valueC + weightC(x-i+2,y-j+2)*I_noise(newX+1,newY+1);
            end
        end
        CannyGR(i+1,j+1) = valueR;
        CannyGC(i+1,j+1) = valueC;
    end
end


CannyG = sqrt(CannyGR.^2 + CannyGC.^2);
CannyG_m = zeros(h,w,3,'uint8');
CannyG_m(:,:,1) = CannyG;
CannyG_m(:,:,2) = CannyG;
CannyG_m(:,:,3) = CannyG;
%figure;
%imshow(CannyG_m);

% step 3: Non-maximal suppression
arah = atan2 (CannyGC, CannyGR);
arah = arah*180/pi;

for i=1:h
    for j=1:w
        if arah(i,j) < 0
            arah(i,j) = arah(i,j) + 360;
        end
    end
end


adjustedArah = zeros(h,w);
for i=1:h
    for j=1:w
        if ((arah(i, j) >= 0 ) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
            adjustedArah(i,j) = 0;
        elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
            adjustedArah(i,j) = 45;
        elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
            adjustedArah(i,j) = 90;
        elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
            adjustedArah(i,j) = 135;
        end
    end
end

CannyGN = zeros(h,w);
for i=2:h-1
    for j=2:w-1
        if adjustedArah(i,j) == 0
            if CannyG(i,j) > CannyG(i,j-1) && CannyG(i,j) > CannyG(i,j+1)
                CannyGN(i,j) = CannyG(i,j);
            end
        elseif adjustedArah(i,j) == 45
            if CannyG(i,j) > CannyG(i+1,j-1) && CannyG(i,j) > CannyG(i-1,j+1)
                CannyGN(i,j) = CannyG(i,j);
            end
        elseif adjustedArah(i,j) == 90
            if CannyG(i,j) > CannyG(i+1,j) && CannyG(i,j) > CannyG(i-1,j)
                CannyGN(i,j) = CannyG(i,j);
            end
        else
            if CannyG(i,j) > CannyG(i-1,j-1) && CannyG(i,j) > CannyG(i+1,j+1)
                CannyGN(i,j) = CannyG(i,j);
            end
        end
    end
end

CannyGN_m = zeros(h,w,3,'uint8');
CannyGN_m(:,:,1) = CannyGN;
CannyGN_m(:,:,2) = CannyGN;
CannyGN_m(:,:,3) = CannyGN;
%figure;
%imshow(CannyGN_m);

% Step 4: Hysteretic thresholding & Step 5: Connected component labeling method
CannyEdge = zeros(h,w);
for i=2:h-1
    for j=2:w-1
        if CannyGN(i,j)>= T_H
            CannyEdge(i,j) = 255;
        elseif CannyGN(i,j)< T_L
            continue
        elseif CannyGN(i-1,j-1) >= T_H || CannyGN(i,j-1) >= T_H || CannyGN(i+1,j-1) >= T_H || CannyGN(i-1,j) >= T_H || CannyGN(i+1,j) >= T_H || CannyGN(i-1,j+1) >= T_H || CannyGN(i,j+1) >= T_H || CannyGN(i+1,j+1) >= T_H
            CannyEdge(i,j) = 255;
        end
    end
end

CannyEdge_m = zeros(h,w,3,'uint8');
CannyEdge_m(:,:,1) = CannyEdge;
CannyEdge_m(:,:,2) = CannyEdge;
CannyEdge_m(:,:,3) = CannyEdge;
figure('name','canny Edge');
imshow(CannyEdge_m);

edgemap = CannyEdge;
end