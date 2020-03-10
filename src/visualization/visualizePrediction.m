%% Parameters
% pedestrians(struct) - the pedestrians object
% frame_index(int) - the index of frames
function [] = visualizePrediction(pedestrians, frame_index)
    if exist('../dataset/human_images/','dir') == 0
        disp(fprintf("path: %s does not exist.\nCreating one.", '../dataset/human_images/'));
        mkdir('../dataset/human_images/'); 
    end
    
    for scale = 1:size(pedestrians.sliding,2)
        pedestrians.sliding(scale).windows(:,:,frame_index)
        nRows = pedestrians.sliding(scale).nRows;
        nCols = pedestrians.sliding(scale).nColumns;
        num = 0;
        for rowindex = 1:nRows
            for colindex = 1:nCols
                if pedestrians.sliding(scale).windows(rowindex, colindex, frame_index).label_HOG_SVM == 1
                    num = num + 1;
                    % display all images which are predicted as human image
                    image = pedestrians.sliding(scale).windows(rowindex, colindex, frame_index).image; 
                    imshow(image)
                    title(strcat('scale size:',num2str(pedestrians.sliding(scale).scale)),'FontSize',10)
                    
                    imageName = strcat('scale_',num2str(pedestrians.sliding(scale).scale),'_frame_',num2str(frame_index),...
                        '_img_',num2str(num),'.jpg');
                    
                    saveas(gcf,fullfile("../dataset/human_images/",imageName))
                    pause(0.5)
                end
            end
        end
        disp(fprintf("There are %d sub-images predicted as 1 with scale_index %d, frame_index %d",num, scale, frame_index))
    end
end
