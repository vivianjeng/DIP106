% DIP Homework Assignment #1 
% May 28, 2018
% Name: ¾G¶®¤å
% ID #: R06922097
% email: r06922097@ntu.edu.tw
%###############################################################################% 
% WARM-UP: SIMPLE MANIPULATIONS
% Implementation 1: Compute the average of R,G,B
% Implementation 2: Main diagonal flipping.
% M-file name: gray.m
% Usage: gray
% Output image: gary_level.raw, B.raw
% Parameters: NONE
% Input image path: 'raw/samples1.raw'
%###############################################################################%
 
disp('Running "gray"...'); 
gray; 
disp('Done, "gray", output image is "gray_level.raw","B.raw"');
%###############################################################################% 
% Problem 1: IMAGE ENHANCEMENT
% Implementation 1: dividing the intensity values by 3
% Implementation 2: Histogram equalization
% Implementation 3: Local histogram equalization
% Implementation 4: Log transform, inverse log transform, power-law
%                   transform
% M-file name: intensity.m, PlotHistogram.m
% Usage: equalization
% Output image: D.raw, H.raw, L.raw
% Parameters: blocksize = 15;
%             log transformation c=120;
%             inverse log transformation c=8;
%             power-law transformation c=3; gamma=1.1;
% Input image path: 'raw/samples2.raw'
%###############################################################################%
 
disp('Running "equalization"...'); 
equalization; 
disp('Done, "equalization", output image is "D.raw","H.raw","L.raw"');
%###############################################################################%
% Problem 2: NOISE REMOVAL
% Implementation 1: gaussian noise image
% Implementation 2: salt-and-pepper noise
% Implementation 3: low-pass filtering
% Implementation 4: non-linear filtering
% Implementation 5: PSNR
% Implementation 6: wrinkle removal:non-linear filtering
% M-file name: noise.m
% Usage: noise
% Output image: G_1.raw, S_1.raw, R_G.raw, R_S.raw, remove_wrinkles.raw
% Parameters: Gaussian noise c = 20;
%             salt-and-pepper nosie threshold = 0.002;
%             low-pass filtering weight = [1,1,1;1,1,1;1,1,1]*(1/9);
%             non-linear filtering blocksize=3;
%             remove wrinkles blocksize=5;
% Input image path: 'raw/samples3.raw'
%                   'raw/samples4.raw'
%###############################################################################%
 
disp('Running "noise"...'); 
noise;
disp('Done, "noise", output image is "G_1.raw","S_1.raw","R_G.raw","R_S.raw","remove_wrinkles.raw"');
%###############################################################################%
