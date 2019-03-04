clearvars; close all; clc;

% Allow Matlab to access functions in subdirectories 
addpath(genpath(pwd));

% Load 'bottle underfilled' images
dirUnderfilled = 'Pictures/1-UnderFilled/';
imagesUnderfilled = dir(fullfile(dirUnderfilled,'*.jpg'));

% Load 'bottle overfilled' images
dirCapMissing = 'Pictures/6-CapMissing/';
capMissing = dir(fullfile(dirCapMissing,'*.jpg'));

% Load 'no label' images
dirLabelMissing = 'Pictures/3-NoLabel/';
imagesLabelMissing = dir(fullfile(dirLabelMissing,'*.jpg'));

numImages = 10;
noiseLevel = 0.0:0.005:0.35;

% Preallocate arrays to store results
resultsUF = zeros(1,length(noiseLevel));
resultsCM = zeros(1,length(noiseLevel));
resultsLM = zeros(1,length(noiseLevel));

% Check each folder individually to save time
% 1 = underfilled, 2 = cap missing, 3 = label missing
for switchFolder = 1:3 
        
    % Use noise level as index for the results
    for i = 1:length(noiseLevel)
        faultCount = 0;

        % Loop over each image
        for j = 1:numImages

            switch switchFolder % Check each folder individually to save time
                % For each, load image, apply gaussian noise and check fault
                case 1
                    file = fullfile(dirUnderfilled, imagesUnderfilled(j).name);
                    image = imread(file);
                    imageWNoise = imnoise(image, 'gaussian', 0, noiseLevel(i));
                    faultCount = faultCount + checkBottleUnderfilled(imageWNoise);
                case 2
                    file = fullfile(dirCapMissing, capMissing(j).name);
                    image = imread(file);
                    imageWNoise = imnoise(image, 'gaussian', 0, noiseLevel(i));
                    faultCount = faultCount + checkCapMissing(imageWNoise);
                case 3
                    file = fullfile(dirLabelMissing, imagesLabelMissing(j).name);
                    image = imread(file);
                    imageWNoise = imnoise(image, 'gaussian', 0, noiseLevel(i));
                    faultCount = faultCount + checkLabelMissing(imageWNoise);
            end
        end

        switch switchFolder % Add results to an appropriate array
            case 1
                resultsUF(i) = resultsUF(i) + ((faultCount/numImages)*100);
            case 2
                resultsCM(i) = resultsCM(i) + ((faultCount/numImages)*100);
            case 3 
                resultsLM(i) = resultsLM(i) + ((faultCount/numImages)*100);
        end
    end
end


% Plot and save results for bottle underfilled
figure;
bar(noiseLevel, resultsUF(1, :), 'r');
title('Performance - Underfilled');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Underfilled');
saveas(gcf,'ResultsPartOne/BottleUnderfilledResults.png')

% Plot and save results for bottlecap missing
figure;
bar(noiseLevel, resultsCM(1, :), 'g');
title('Performance - Cap Missing');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottlecap Missing');
saveas(gcf,'ResultsPartOne/BottleCapMissingResults.png')

% Plot and save results for bottle label missing
figure;
bar(noiseLevel, resultsLM(1, :), 'b');
title('Performance - Label Missing');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Label Missing');
saveas(gcf,'ResultsPartOne/BottleLabelMissingResults.png')


% Plot and save overall results
figure;
plot(noiseLevel, resultsUF(1, :), 'r', 'LineWidth' , 2); hold on;
plot(noiseLevel, resultsCM(1, :), 'g', 'LineWidth' , 2); hold on;
plot(noiseLevel, resultsLM(1, :), 'b', 'LineWidth' , 2); hold on;
title('Performance - Overall');
xlabel('Noise Level')
ylabel('Accuracy %');
ylim([0,  105])
grid on;
legend('Bottle Underfilled', 'Bottlecap Missing', 'Bottle Label Missing');
saveas(gcf,'ResultsPartOne/OverallResults.png')
