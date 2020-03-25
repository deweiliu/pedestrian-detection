function [NMSImage, data] = nonMaxSuppressionPerFrame(pedestrians, threshold, frameIndex)
    newPedestrian = true;
    image = pedestrians.images(:, :, :, frameIndex);
    sliding = pedestrians.sliding;
    data = [];

    while newPedestrian

        [scaleIndex, rowIndex, columnIndex] = findPedestrian(sliding, frameIndex);

        if scaleIndex == 0
            newPedestrian = false;
        else
            target = sliding(scaleIndex).windows(rowIndex, columnIndex, frameIndex);
            sliding = removePedestrian(sliding, frameIndex, target);
            box.x = target.x;
            box.y = target.y;
            box.width = target.width;
            box.height = target.height;

            data = [data; box];

            image = mergeImageBounding(image, box, "green");
        end

    end

    NMSImage.image = image;
    NMSImage.title = sprintf("%d Pedestrians", size(data));
end

function [scaleIndex, rowIndex, columnIndex] = findPedestrian(sliding, frameIndex)
    nScale = size(sliding, 2);

    for scaleIndex = 1:nScale
        nRows = sliding(scaleIndex).nRows;
        nColumns = sliding(scaleIndex).nColumns;

        for rowIndex = 1:nRows

            for columnIndex = 1:nColumns

                if sliding(scaleIndex).windows(rowIndex, columnIndex, frameIndex).label_HOG_SVM == true
                    return;
                end

            end

        end

    end

    scaleIndex = 0;

end

function [sliding] = removePedestrian(sliding, frameIndex, target)
    nScale = size(sliding, 2);

    for scaleIndex = 1:nScale
        nRows = sliding(scaleIndex).nRows;
        nColumns = sliding(scaleIndex).nColumns;

        for rowIndex = 1:nRows

            for columnIndex = 1:nColumns
                window = sliding(scaleIndex).windows(rowIndex, columnIndex, frameIndex);

                if window.label_HOG_SVM == true

                    if isSamePedestrian(target, window)
                        sliding(scaleIndex).windows(rowIndex, columnIndex, frameIndex).label_HOG_SVM = false;
                    end

                end

            end

        end

    end

end

function isSame = isSamePedestrian(window1, window2)
    interction = rectint(window1.position, window2.position);
    targetArea = window1.width * window2.height;

    if interction > targetArea / 2
        isSame = true;
    else
        isSame = false;
    end

end