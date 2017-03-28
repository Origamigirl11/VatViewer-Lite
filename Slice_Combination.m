vatviewerGlobalVars;

% load the EAT variable from the results file
resultsFileName = 'subject12_i_results.mat';

% resultsFile = get(handles.resultsFileName,'FileName');
load(resultsFileName,'EAT3d');
load(resultsFileName,'CAT3d');

% pull out current frame of data
% currSliceNum = get(handles.slider_imageSlice,'Value');
numSlices = size(EAT3d,3); % 3rd dim is slices


% create base of output filenames based on results filename
indexDot = find(resultsFileName == '.');
textOutName = resultsFileName(1,1:indexDot-1);
textOutName = strcat(textOutName,'_CGB_EAT_CAT_COMPOSITE.txt');


% open and write top part of file
fid = fopen(textOutName,'w');
fprintf(fid,'%d\n',numSlices);

% loop through number of slices
for i=1:numSlices
    
    % write frame number
    fprintf(fid,'#%d\n',i-1);

    % pull out this frame of data, convert to pure binary, and write out
    % the boundary pixels as the contours
    imageSlice_EAT = EAT3d(:,:,numSlices);
    imageSlice_CAT = CAT3d(:,:,numSlices);

    % convert image to true binary
    binImageEAT = (imageSlice_EAT>0);
    binImageCAT = (imageSlice_CAT>0);

    binImageComposite=or(binImageEAT,binImageCAT);

%     clear imageSlice_EAT;
%     clear imageSlice_CAT;

   
    [B,L] = bwboundaries(binImageComposite,8,'holes');
    
    % number of objects algorithm traced
    numObjects = max(size(B));
    
    if numObjects > 0
    
        % count up the total number of points for all objects
        totalNumPointsOnFrame = 0;
        for j=1:numObjects
            points = B{j};
            numPtsObject = size(points,1); % column wise, num rows is num pts
            totalNumPointsOnFrame = totalNumPointsOnFrame + numPtsObject;
        end

        % write out the number of points on this frame
        fprintf(fid,'%d\n',totalNumPointsOnFrame);

        % loop through each object and write points
        for j=1:numObjects
            points = B{j};
            numPtsObject = size(points,1);
            for k=1:numPtsObject
                fprintf(fid,'%.3f %.3f %.3f\n',points(k,2)-1,points(k,1),i-1);
            end
            plot(points(:,2),points(:,1),'k','LineWidth',1);
        end
   
        %pause;
        
    else
        % write out zero for this frame
        fprintf(fid,'%d\n',0);

    end
    
end

% close file
hold off;
fclose(fid);

