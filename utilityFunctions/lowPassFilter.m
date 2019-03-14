function filteredImage = lowPassFilter(image, cutoffFreq)
    % Get image dimensions
    [h, w, c] = size(image);

    % Get centered version of discrete Fourier transform
    DFT = fftshift(fft2(image));
    
    % Calculate image centerpoint
    hr = (h-1)/2; 
    hc = (w-1)/2; 
    [X, Y] = meshgrid(-hc:hc, -hr:hr);
    
    % Construct ideal low-pass filter
    freqFilt = sqrt((X/hc).^2 + (Y/hr).^2); 
    freqFilt = double(freqFilt <= cutoffFreq);
    
    % Construct the RGB output of the centered filter
    imageOut = zeros(size(DFT)); 
    for channel = 1:c 
        imageOut(:, :, channel) = DFT(:, :, channel) .* freqFilt; 
    end 
    
    % Centred filter on the spectrum
    filteredImage = abs(ifft2(ifftshift(imageOut)));

    % Normalize to the range [1, 256]
    filteredImage = uint8(256 * mat2gray(filteredImage));
end