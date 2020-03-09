function [result] = colourHistogram(img, quantizationColors)
    % Perform quantization to reduce feature count
    [imgQ, map] = rgb2ind(img, quantizationColors, 'nodither');
    imgQ = ind2rgb(imgQ, map);

    % Get RGB values
    r = imgQ(:,:,1);
    g = imgQ(:,:,2);
    b = imgQ(:,:,3); 

    % Get histogram values for each colour
    redHist = imhist(r, quantizationColors);
    greenHist = imhist(g, quantizationColors);
    blueHist = imhist(b, quantizationColors);
    result = [redHist.', greenHist.', blueHist.'];
end

