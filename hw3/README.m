% DIP Homework Assignment #3 
% May 2, 2018
% Name: Jeng,Ya-wen
% ID #: R06922097
% email: r06922097@ntu.edu.tw
%###############################################################################% 
% Problem 1: Morphological Processing
% Implementation 1: boundary extraction
% Implementation 2: count the number of objects
% Implementation 3: skeletonizing
% M-file name: Morphological.m, readraw.m, writeraw.m
% Usage: Morphological
% Output image: B.raw, countObjects.raw, S.raw
% Parameters: NONE
% Input image path: 'raw/samples1.raw'
%###############################################################################%
 
disp('Running "Morphological"...'); 
Morphological; 
disp('Done, "Morphological", output image is "B.raw","countObjects.raw","S.raw"');
%###############################################################################%
% Problem 2:  Texture Analysis
% Implementation 1: Law¡¦s method
% Implementation 2: texture syntext
% M-file name: texture.m, textureFilter, readraw.m, writeraw.m
% Usage: texture
% Output image: C.raw, D.raw
% Parameters: 5*5 filter
% Input image path: 'raw/samples2.raw'
% [!]Note: "kmeans" will cause the seperation to perform not well. it's
%    random label index.
%###############################################################################%
 
disp('Running "texture"...'); 
texture;
disp('Done, "texture", output image is "K.raw"');
%###############################################################################%
