%% .Extract Boundary
I = readraw('raw/sample1.raw');

[h,w] = size(I);
G = zeros(h,w);
I = I/255;

for i=2:h-1
    for j=2:w-1
        if I(i-1,j-1) && I(i-1,j) && I(i,j-1) && I(i+1,j+1) && I(i,j) && I(i-1,j+1) && I(i+1,j-1) && I(i,j+1) && I(i+1,j)
            G(i,j) = 1;
        end
    end
end


edge = zeros(h,w);

for i=1:h
    for j=1:w
        if I(i,j) == G(i,j)
            edge(i,j) = 0;
        else
            edge(i,j) = 1;
        end
    end
end


figure;
imshow(edge);
writeraw(edge,'B.raw');


%% .Count the number of objects

label = edge;

% Step 1. set background color to 0.5(gray)
label(1,1) = 0.5;
for i=2:h
    if label(i-1,1) == 0.5
        label(i,1) = 0.5;
    end
end

for j=2:w
    if label(1,j-1) == 0.5
        label(1,j) = 0.5;
    end
end

% from left-top
for i=2:h
    for j=2:w
        if (label(i-1,j) ==0.5 || label(i,j-1)==0.5) && label(i,j)~=1
            label(i,j) = 0.5;
        end
    end
end

% from right-bottom
for i=h-1:-1:1
    for j=w-1:-1:1
        if (label(i+1,j) ==0.5 || label(i,j+1)==0.5) && label(i,j)~=1
            label(i,j) = 0.5;
        end
    end
end

% fill inner shape
for i=1:h
    for j=1:w
        if label(i,j)==1
            label(i,j) = 0;
        end
    end
end


count_image = label;

count = 0;

k = find(count_image==0);
while ~isempty(k)
    find_first = false;
    % from left-top
    for i=2:h
        for j=2:w
            if ~find_first
                if count_image(i,j) == 0
                    find_first = true;
                    count = count+1;
                    count_image(i,j) = count;
                end
            elseif find_first
                if (count_image(i-1,j)==count || count_image(i-1,j-1)==count || count_image(i,j-1)==count) && (count_image(i,j)==0)
                    count_image(i,j) = count;
                end
            end
        end
    end

    % from right-bottom
    for i=h-1:-1:1
        for j=w-1:-1:1
            if (count_image(i+1,j)==count || count_image(i+1,j+1)==count || count_image(i,j+1)==count) && (count_image(i,j)==0)
                count_image(i,j) = count;
            end
        end
    end
    k = find(count_image==0);
end

% for visualization
for i=1:h
    for j=1:w
        if count_image(i,j) == 0.5
            count_image(i,j) = 0;
        else
            count_image(i,j) = count_image(i,j)/count;
        end
    end
end
figure;
imshow(count_image);
writeraw(count_image,'countObjects.raw');
fprintf('object counts: %d\n',count);


%% .Skeletonization

changing = 1;
skeletoned = I;
deletion = ones(h, w);
while changing
    changing = 0;
    % Setp 1
    for i=2:h-1
        for j = 2:w-1
            P = [skeletoned(i,j) skeletoned(i-1,j) skeletoned(i-1,j+1) skeletoned(i,j+1) skeletoned(i+1,j+1) skeletoned(i+1,j) skeletoned(i+1,j-1) skeletoned(i,j-1) skeletoned(i-1,j-1) skeletoned(i-1,j)]; % P1, P2, P3, ... , P8, P9, P2
            if (skeletoned(i,j) == 1 &&  sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(6)==0 && P(4)*P(6)*P(8)==0)   % conditions
                A = 0;
                for k = 2:size(P,2)-1
                    if P(k) == 0 && P(k+1)==1
                        A = A+1;
                    end
                end
                if (A==1)
                    deletion(i,j)=0;
                    changing = 1;
                end
            end
        end
    end
    skeletoned = skeletoned.*deletion;  % the deletion must after all the pixels have been visited
    % Step 2 
    for i=2:h-1
        for j = 2:w-1
            P = [skeletoned(i,j) skeletoned(i-1,j) skeletoned(i-1,j+1) skeletoned(i,j+1) skeletoned(i+1,j+1) skeletoned(i+1,j) skeletoned(i+1,j-1) skeletoned(i,j-1) skeletoned(i-1,j-1) skeletoned(i-1,j)];
            if (skeletoned(i,j) == 1 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(8)==0 && P(2)*P(6)*P(8)==0)   % conditions
                A = 0;
                for k = 2:size(P,2)-1
                    if P(k) == 0 && P(k+1)==1
                        A = A+1;
                    end
                end
                if (A==1)
                    deletion(i,j)=0;
                    changing = 1;
                end
            end
        end
    end
    skeletoned = skeletoned.*deletion;
end

figure;
imshow(skeletoned);
writeraw(skeletoned,'S.raw');