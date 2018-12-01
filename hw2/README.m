% DIP Homework Assignment #2 
% April 11, 2018
% Name: ¾G¶®¤å
% ID #: R06922097
% email: r06922097@ntu.edu.tw
%###############################################################################% 
% Problem 1: EDGE DETECTION
% Implementation 1: first order edge detection
% Implementation 2: second order edge detection
% Implementation 3: canny edge detection
% M-file name: edgeDetection.m, FirstEdgeDetection.m,
%              SecondEdgeDetection.m, CannyEdgeDetection.m
% Usage: edgeDetection
% Output image: firstOrderEdge.raw, secondOrderEdge.raw, CannyEdge.raw,
%               noiseImageEdge.raw
% Parameters: first order edge detection T=70;
%             Canny edge detection T_H = 120, T_L = 90;
%             Second order edge detection T=100, sigma = 1;
% Input image path: 'raw/samples1.raw','raw/samples2.raw'
%###############################################################################%
 
disp('Running "edgeDetection"...'); 
edgeDetection; 
disp('Done, "edgeDetection", output image is "firstOrderEdge.raw","secondOrderEdge.raw","CannyEdge.raw","noiseImageEdge.raw"');
%###############################################################################%
% Problem 2:  GEOMETRICAL MODIFICATION
% Implementation 1: unsharp masking
% Implementation 2: swarping
% M-file name: edgeCrispening.m
% Usage: edgeCrispening
% Output image: C.raw, D.raw
% Parameters: edge crispening: c=3/5 w = 1/9.*[1,1,1;1,1,1;1,1,1];
%             warping: u = ceil(0.96*i+15*sin(-2*pi*j/220+1))
%                      v = ceil(0.96*j+17*sin(-2*pi*i/160));
% Input image path: 'raw/samples3.raw'
%###############################################################################%
 
disp('Running "edgeCrispening"...'); 
edgeCrispening;
disp('Done, "edgeCrispening", output image is "C.raw","D.raw"');
%###############################################################################%
