clearvars; close all; clc;

% Allow Matlab to access functions in subdirectories 
addpath(genpath(pwd));

% Load 'bottle underfilled' images
dirUnderfilled = 'Pictures/1-UnderFilled/';
imagesUnderfilled = dir(fullfile(dirUnderfilled,'*.jpg'));

% Load 'cap missing' images
dirCapMissing = 'Pictures/6-CapMissing/';
imagesCapMissing = dir(fullfile(dirCapMissing,'*.jpg'));

% Load 'no label' images
dirLabelMissing = 'Pictures/3-NoLabel/';
imagesLabelMissing = dir(fullfile(dirLabelMissing,'*.jpg'));

numTests = 5;
numImages = 10;
noiseRange = 0.0:0.005:0.35;

% Preallocate arrays to store results
results = zeros(3, length(noiseRange));

for currentTest = 1:numTests
    % Check each folder individually to save performance time
    % 1 = underfilled, 2 = cap missing, 3 = label missing
    for switchFolder = 1:3 

        % Use noise level as index for the results
        for i = 1:length(noiseRange)
            faultCount = 0;

            % Loop over each image
            for j = 1:numImages

                switch switchFolder % Check each folder individually to save time
                    % For each, load image, apply gaussian noise and check fault
                    case 1
                        file = fullfile(dirUnderfilled, imagesUnderfilled(j).name);
                        image = imread(file);
                        imageWithNoise = imnoise(image, 'gaussian', 0, noiseRange(i));
                        faultCount = faultCount + checkBottleUnderfilled(imageWithNoise);
                    case 2
                        file = fullfile(dirCapMissing, imagesCapMissing(j).name);
                        image = imread(file);
                        imageWithNoise = imnoise(image, 'gaussian', 0, noiseRange(i));
                        faultCount = faultCount + checkCapMissing(imageWithNoise);
                    case 3
                        file = fullfile(dirLabelMissing, imagesLabelMissing(j).name);
                        image = imread(file);
                        imageWithNoise = imnoise(image, 'gaussian', 0, noiseRange(i));
                        faultCount = faultCount + checkLabelMissing(imageWithNoise);
                end
            end

            accuracy = (faultCount/numImages)*100;

            switch switchFolder % Add results to an appropriate array
                case 1
                    results(switchFolder, i) = results(switchFolder, i) + accuracy;
                case 2
                    results(switchFolder, i) = results(switchFolder, i) + accuracy;
                case 3
                    results(switchFolder, i) = results(switchFolder, i) + accuracy;
            end
        end
    end
end

% Divide by number of tests to obtain average performance
results = results ./ numTests;

% Plot and save results for bottle underfilled
figure;
bar(noiseRange, results(1, :), 'r');
title('Performance - Underfilled');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Underfilled');
saveas(gcf,'Results/PartOne/BottleUnderfilledResults.png')

% Plot and save results for bottlecap missing
figure;
bar(noiseRange, results(2, :), 'g');
title('Performance - Cap Missing');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottlecap Missing');
saveas(gcf,'Results/PartOne/BottleCapMissingResults.png')

% Plot and save results for bottle label missing
figure;
bar(noiseRange, results(3, :), 'b');
title('Performance - Label Missing');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Label Missing');
saveas(gcf,'Results/PartOne/BottleLabelMissingResults.png')


% Plot and save overall results
figure;
plot(noiseRange, results(1, :), 'r', 'LineWidth', 2); hold on;
plot(noiseRange, results(2, :), 'g', 'LineWidth', 2); hold on;
plot(noiseRange, results(3, :), 'b', 'LineWidth', 2); hold on;
title('Performance - Overall');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Underfilled', 'Bottlecap Missing', 'Bottle Label Missing');
saveas(gcf,'Results/PartOne/OverallResults.png')
