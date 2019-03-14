clearvars; close all; clc;

% Allow Matlab to access functions in subdirectories 
addpath(genpath(pwd));

% Load 'bottle overfilled' images
dirCapMissing = 'Pictures/6-CapMissing/';
imagesCapMissing = dir(fullfile(dirCapMissing,'*.jpg'));

numImages = length(imagesCapMissing);
numTests = 5;
noiseLevel = 0.12; % Noise level of 0.12 results in an accuracy of 10% when no filtering

range = 0.05:0.05:1; % Range to test different filters on 

% Initialise results arrays
results = zeros(4, length(range));

for currentTest = 1:numTests
    
    for switchFilter = 1:4 % Loop 4 times, one for each filter type

        for N = 1:length(range) % Loop over the test parameter range

            faultCount = 0;

            for j = 1:numImages % Loop over each image

                file = fullfile(dirCapMissing, imagesCapMissing(j).name); % Read file
                image = imread(file);

                imageWithNoise = imnoise(image, 'gaussian', 0, noiseLevel); % Apply noise

                switch switchFilter % Apply filter on current image depending on current case
                    case 1 % Average filtering
                        imageAfterFilt = imfilter(imageWithNoise, ones(N, N)/N^2);            
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 2 % Median Filtering
                        imageAfterFilt = medfilt2(rgb2gray(imageWithNoise), [N, N]);
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 3 % Gaussian Filtering
                        imageAfterFilt = imgaussfilt(imageWithNoise, range(N)*4);
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 4 % Low-pass filtering (freq. filtering)
                        imageAfterFilt = lowPassFilter(imageWithNoise, range(N));
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                end
            end

            accuracy = (faultCount/numImages)*100;

            switch switchFilter % Store the results
                case 1
                    results(switchFilter, N) = results(switchFilter, N) + accuracy;
                case 2
                    results(switchFilter, N) = results(switchFilter, N) + accuracy;
                case 3
                    results(switchFilter, N) = results(switchFilter, N) + accuracy;
                case 4
                    results(switchFilter, N) = results(switchFilter, N) + accuracy;
            end
        end
    end
end

results = results ./ numTests; % Obtain average performance
kernelRange = 1:length(range); % Generate array for X-axes

% Plot the Averaging Filter Performance
figure;
a1 = area(kernelRange, results(1,:));
title('Performance - Averaging Filter (\sigma = 0.12)');
xlabel('Kernel Size (N)')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
set(a1, 'FaceColor','r'); clear a1;
saveas(gcf,'Results/PartTwo/ResultsAvg.png')

% Plot the Median Filter Performance
figure;
a2 = area(kernelRange, results(2,:));
title('Performance - Median Filter (\sigma = 0.12)');
xlabel('Neighbourhood Size (N x N)')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
set(a2, 'FaceColor','g');
saveas(gcf,'Results/PartTwo/ResultsMed.png')

% Plot the Gauss Filter Performance
figure;
a3 = area(range*4, results(3,:));
title('Performance - Gaussian Filter (\sigma = 0.12)');
xlabel('Std Deviation')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
set(a3, 'FaceColor','b');
saveas(gcf,'Results/PartTwo/ResultsGauss.png')

% Plot the LPF Performance
figure;
a4 = area(range, results(4,:));
title('Performance - Low-Pass Filter (\sigma = 0.12)');
xlabel('Cutoff Frequency')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
set(a4, 'FaceColor','y');
saveas(gcf,'Results/PartTwo/ResultsLPF.png')