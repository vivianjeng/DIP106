I = readraw('raw/sample3.raw');

c = 3/5;
H = 1/9.*[1,1,1;1,1,1;1,1,1];

F_L =conv2(I, H, 'same');

G = zeros(512,512);
for i=1:512
    for j=1:512
        G(i,j) = c/(2*c-1)*I(i,j)-(1-c)/(2*c-1)*F_L(i,j);
    end
end

G_m = zeros(512,512,3,'uint8');
G_m(:,:,1) = G;
G_m(:,:,2) = G;
G_m(:,:,3) = G;
imshow(G_m);
writeraw(G,'C.raw');

new_img = zeros(512,512);
for i=1:512
    for j=1:512
        new_x = ceil(0.96*i+15*sin(-2*pi*j/220+1));
        new_y = ceil(0.96*j+17*sin(-2*pi*i/160));
        if new_x < 1
            new_x = 1;
        elseif new_x > 512
            new_x = 512;
        end
        if new_y < 1
            new_y = 1;
        elseif new_y > 512
            new_y = 512;
        end
        new_img(new_y,new_x) = G(i,j);
    end
end


for i=2:511
    for j=2:511
        if new_img(i,j) == 0
            thres = 4;
            neighbor = 0;
            for x=i-1:i+1
                for y=j-1:j+1
                    if new_img(x,y) ~= 0
                        neighbor = neighbor +1 ;
                    end
                end
            end
            if neighbor >= thres
                new_img(i,j) = (new_img(i-1,j) + new_img(i+1,j) + new_img(i,j-1) + new_img(i,j+1))/4;
            end
        end
    end
end

new_img_m = zeros(512,512,3,'uint8');
new_img_m(:,:,1) = new_img;
new_img_m(:,:,2) = new_img;
new_img_m(:,:,3) = new_img;
figure('name','warping C');
imshow(new_img_m);
writeraw(new_img,'D.raw');