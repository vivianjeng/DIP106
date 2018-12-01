% DIP Homework Assignment #4 
% May 30, 2018
% Name: Jeng,Ya-wen
% ID #: R06922097
% email: r06922097@ntu.edu.tw
%###############################################################################% 
% Problem 1: Optical Character Recognition (OCR)
% Implementation 1: TrainingSet preprocessing
% Implementation 2: Sample1, Sample2 preprocessing
% Implementation 3: Recognition
% M-file name: OCR.m, readraw.m
% Usage: OCR
% Output image: NONE
% Parameters: Using different parameters in Sample1 and Sample2 to achieve
%             100% accuracy.
%             Sample1: total_score = score_1*0.45+score_2*0.8+score_3*2,
%                      only recognizing alphabets and numbers.
%             Sample2: total_score = score_1*0.45+score_2*1.15+score_3*2,
%                      using all training data.
%             See Report.pdf to know more infomation about 'scores'.
% Input image path: 'raw/TrainingSet.raw','raw/sample1.raw','raw/sample2.raw'
%###############################################################################%
 
disp('Running "OCR"...'); 
OCR; 
disp('Done, " OCR"');
%###############################################################################%
