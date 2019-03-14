clearvars; close all; clc;

% Load Sample Image
dirCapMissing = 'Pictures/6-CapMissing/';
imagesCapMissing = dir(fullfile(dirCapMissing,'*.jpg'));
file = fullfile(dirCapMissing, imagesCapMissing(3).name); % Read file
image = imread(file);

% Generate montage for noise (sigma = 0.25 & sigma = 1)
noise = [0.25, 1];
imageWithLessNoise = imnoise(image, 'gaussian', 0, noise(1));
imageWithNoise = imnoise(image, 'gaussian', 0, noise(2)); 
noiseMontage = cat(2,image,imageWithLessNoise,imageWithNoise);
figure('Name','Adding Noise (Sigma = 0, Sigma = 0.25, Sigma = 1)','NumberTitle','off');
montage(noiseMontage);
saveas(gcf,'Results/SampleImages/AddingNoise.png');

% Ideal filter parameters 
N = 5; % Avg & Med
stdDev = 3; % Gauss
cutoffFreq = 0.1; % LPF

% Compare image after Avg Filtering
imageAfterAvg = imfilter(imageWithNoise, ones(N, N)/N^2);
figure('Name','Average Filtering','NumberTitle','off');
imshowpair(imageWithNoise, imageAfterAvg, 'montage');
saveas(gcf,'Results/SampleImages/Averaging.png');

% Compare image after Median Filtering
imageAfterMed = medfilt2(rgb2gray(imageWithNoise), [N, N]);
figure('Name','Median Filtering','NumberTitle','off');
imshowpair(imageWithNoise, imageAfterMed, 'montage');
saveas(gcf,'Results/SampleImages/Median.png');

% Compare image after Gauss Filtering
imageAfterGauss = imgaussfilt(imageWithNoise, stdDev);
figure('Name','Gaussian Filtering','NumberTitle','off');
imshowpair(imageWithNoise, imageAfterGauss, 'montage');
saveas(gcf,'Results/SampleImages/Gaussian.png');

% Compare image after LPF Filtering
imageAfterLPF= lowPassFilter(imageWithNoise, cutoffFreq);
figure('Name','Low-Pass Filtering','NumberTitle','off');
imshowpair(imageWithNoise, imageAfterLPF, 'montage');
saveas(gcf,'Results/SampleImages/LPF.png');

% Compare image after LPF Filtering to Binary image to explain high performance
figure('Name','Binary Image','NumberTitle','off');
binaryImage = imbinarize(rgb2gray(imageAfterLPF), double(120/256)); % Threshold equal to threshold used in checkCapMissing()
binaryImage = im2uint8(binaryImage); % Convert logical to uint8
binaryImage = cat(3, binaryImage, binaryImage, binaryImage); % Gray to 3 channels
binaryMontage = cat(2,image,imageAfterLPF,binaryImage);
montage(binaryMontage);
saveas(gcf,'Results/SampleImages/BinaryImage.png');



