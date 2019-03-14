clearvars; close all; clc;

% Allow Matlab to access functions in subdirectories 
addpath(genpath(pwd));

% Load 'Cap missing' images
dirCapMissing = 'Pictures/6-CapMissing/';
imagesCapMissing = dir(fullfile(dirCapMissing,'*.jpg'));

numImages = length(imagesCapMissing);

noiseRange = 0:0.1:10; 
numTests = 5;

% Ideal filter parameters 
N = 5; % Avg & Med
stdDev = 3; % Gauss
cutoffFreq = 0.1; % LPF

% Initialise results arrays
results = zeros(5, length(noiseRange));

for currentTest = 1:numTests
    for switchFilter = 1:5 % Loop 4 times, one for each filter type

        for i = 1:length(noiseRange) % Loop over the test parameter range

            faultCount = 0;

            for j = 1:numImages % Loop over each image

                file = fullfile(dirCapMissing, imagesCapMissing(j).name); % Read file
                image = imread(file);

                imageWithNoise = imnoise(image, 'gaussian', 0, noiseRange(i)); % Apply noise

                switch switchFilter % Apply filter on current image depending on current case
                    case 1 % No filter
                        faultCount = faultCount + checkCapMissing(imageWithNoise);
                    case 2 % Average filtering
                        imageAfterFilt = imfilter(imageWithNoise, ones(N, N)/N^2);            
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 3 % Median Filtering
                        imageAfterFilt = medfilt2(rgb2gray(imageWithNoise), [N, N]);
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 4 % Gaussian Filtering
                        imageAfterFilt = imgaussfilt(imageWithNoise, stdDev);
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                    case 5 % Low-pass filtering (freq. filtering)
                        imageAfterFilt = lowPassFilter(imageWithNoise, cutoffFreq);
                        faultCount = faultCount + checkCapMissing(imageAfterFilt);
                end
            end

            accuracy = (faultCount/numImages)*100;

            switch switchFilter % Store the results
                case 1
                    results(switchFilter, i) = results(switchFilter, i) + accuracy;
                case 2
                    results(switchFilter, i) = results(switchFilter, i) + accuracy;
                case 3
                    results(switchFilter, i) = results(switchFilter, i) + accuracy;
                case 4
                    results(switchFilter, i) = results(switchFilter, i) + accuracy;
                case 5
                    results(switchFilter, i) = results(switchFilter, i) + accuracy;
            end
        end
    end
end

% Divide by number of tests to obtain average performance
results = results ./ numTests;

% Plot the Overall Performance
figure;
plot(noiseRange, results(1, :), 'k', 'LineWidth', 2); hold on;
plot(noiseRange, results(2, :), 'g', 'LineWidth', 2); hold on;
plot(noiseRange, results(3, :), 'y', 'LineWidth', 2); hold on;
plot(noiseRange, results(4, :), 'm', 'LineWidth', 2); hold on;
plot(noiseRange, results(5, :), 'c', 'LineWidth', 2); hold on;
title('System Performance vs Noise Variance');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend({'No Filter', 'Average', 'Median', 'Gaussian', 'Low-Pass'}, 'Location', 'southwest')
saveas(gcf,'Results/PartTwo/OverallPerformance.png')
