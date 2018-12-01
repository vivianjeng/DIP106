I = readraw('raw/sample1.raw');
I_m = zeros(512,512,3,'uint8');
I_m(:,:,1) = I;
I_m(:,:,2) = I;
I_m(:,:,3) = I;
figure('name','original image');
imshow(I_m);

%% .Edge Detecor
% First Edge Detector
FirstOrderEdge = FirstEdgeDetection(I,70);
writeraw(FirstOrderEdge,'firstOrderEdge.raw');

% Canny Edge Detecor
CannyEdge = CannyEdgeDetection(I,120,90);
writeraw(CannyEdge,'CannyEdge.raw');

% Second Edge Detector
SecondOrderEdge = SecondEdgeDetection(I,100,1);
writeraw(SecondOrderEdge,'secondOrderEdge.raw');

%% . Image with noise

I2 = readraw('raw/sample2.raw');

% First Edge Detector
noiseImageEdge = FirstEdgeDetection(I2,70);
writeraw(noiseImageEdge,'noiseImageEdge.raw');