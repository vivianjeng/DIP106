function edgemap = FirstEdgeDetection(I,T)

[h, w] = size(I);

firstOrderGR = zeros(h,w);
firstOrderGC = zeros(h,w);
frame = 3;
hsize = floor(frame/2);
weightR = [-1, 0, 1; -2, 0, 2; -1, 0, 1]*1/4.;
weightC = [1, 2, 1; 0, 0, 0; -1, -2, -1]*1/4.;

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
                valueR = valueR + weightR(x-i+2,y-j+2)*I(newX+1,newY+1);
                valueC = valueC + weightC(x-i+2,y-j+2)*I(newX+1,newY+1);
            end
        end
        firstOrderGR(i+1,j+1) = valueR;
        firstOrderGC(i+1,j+1) = valueC;
    end
end


firstOrderG = sqrt(firstOrderGR.^2 + firstOrderGC.^2);
firstOrderG_m = zeros(h,w,3,'uint8');
firstOrderG_m(:,:,1) = firstOrderG;
firstOrderG_m(:,:,2) = firstOrderG;
firstOrderG_m(:,:,3) = firstOrderG;
%figure;
%imshow(firstOrderG_m);

firstOrderEdge = zeros(h,w);
for i=1:h
    for j=1:w
        if firstOrderG(i,j) > T
            firstOrderEdge(i,j) = 255;
        else
            firstOrderEdge(i,j) = 0;
        end
    end
end

firstOrderEdge_m = zeros(h,w,3,'uint8');
firstOrderEdge_m(:,:,1) = firstOrderEdge;
firstOrderEdge_m(:,:,2) = firstOrderEdge;
firstOrderEdge_m(:,:,3) = firstOrderEdge;
figure('name','first Order Edge');
imshow(firstOrderEdge_m);

edgemap = firstOrderEdge;
end