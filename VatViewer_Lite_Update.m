function varargout = VatViewer_Lite_Update(varargin)
% VATVIEWER_LITE_UPDATE MATLAB code for VatViewer_Lite_Update.fig
%      VATVIEWER_LITE_UPDATE, by itself, creates a new VATVIEWER_LITE_UPDATE or raises the existing
%      singleton*.
%
%      H = VATVIEWER_LITE_UPDATE returns the handle to a new VATVIEWER_LITE_UPDATE or the handle to
%      the existing singleton*.
%
%      VATVIEWER_LITE_UPDATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VATVIEWER_LITE_UPDATE.M with the given input arguments.
%
%      VATVIEWER_LITE_UPDATE('Property','Value',...) creates a new VATVIEWER_LITE_UPDATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VatViewer_Lite_Update_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VatViewer_Lite_Update_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VatViewer_Lite_Update

% Last Modified by GUIDE v2.5 22-Mar-2017 21:37:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VatViewer_Lite_Update_OpeningFcn, ...
                   'gui_OutputFcn',  @VatViewer_Lite_Update_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VatViewer_Lite_Update is made visible.
function VatViewer_Lite_Update_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VatViewer_Lite_Update (see VARARGIN)

vatviewerGlobalVars;

% Choose default command line output for VatViewer_Lite_Update
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VatViewer_Lite_Update wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% set data type to EAT by default on opening

WHICH_TYPE = 'EAT_3D';

TRACING_WHICH_TYPE = 'EAT_3D';



% set the radio button to EAT initially upon loading new data

set(handles.uibuttongroup_fatType,'SelectedObject',...
    handles.radiobutton_EAT);



% set the colormap radio button to gray initially

 set(handles.uibuttongroup_Colormap,'SelectedObject',...
     handles.radiobutton_Gray);
 
 colormap('gray');
 




% disable boundary button

%  set(handles.pushbutton_FindBoundaries,'Enable','off');



% disable tracing button

 set(handles.togglebutton_TraceBoundaries,'Enable','off');



% set flag for loaded data to false

BOOL_LOADED_DATA = 0;



% set flag for tracing to false

BOOL_TRACING_BOUNDARIES = 0;



% --- Outputs from this function are returned to the command line.
function varargout = VatViewer_Lite_Update_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton_resultsFile.
function pushbutton_resultsFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resultsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vatviewerGlobalVars;

[resultsFileName, resultsPath] = uigetfile('*.mat','Choose results file...');



if isequal(resultsFileName,0) || isequal(resultsPath,0)
    disp('User pressed cancel')

else


    

    % display hourglass cursor while loading

    set(handles.figure1,'pointer','watch');

    drawnow;

    

    % display the filename (minus the full path) that the user 

    % selected in the static text 

     texthandle = handles.text_resultsFile;

     set(texthandle,'String',resultsFileName);

    

    % load the workspace from this results file and display overall

    % results as color-coded data as the initial image

    load(resultsFileName);

    disp(sprintf('Loaded results workspace from %s ...',resultsFileName));

    

    % copy correct data type to the one we will use for viewing

    vatviewerLoadTissueData();

    vatviewerSetTissueType();

   

    % set the bounds on the slider based on the size of the EAT data

    numSlices = size(VOL_3D,3); % 3rd dim is slices

    sliderhandle = handles.slider_imageSlice;

    set(sliderhandle,'Max',numSlices);

    set(sliderhandle,'Min',1);

    

    % take the middle slice as the initial image to display

    middleSlice = floor(numSlices / 2);

    imagesc(VOL_3D(:,:,middleSlice),'Parent',handles.axes_image);

    set(sliderhandle,'Value',middleSlice);

    

    % display the file selected in the command window, too

    disp(['User selected ', fullfile(resultsPath, resultsFileName)])

    

    % set appropriate value in frame number label

    set(handles.text_frameNumber,'String',...
        sprintf('Frame Number: %d',uint8(middleSlice)));

    

    % reset back to pointer cursor

    set(handles.figure1,'pointer','arrow');

    

    % set the fat type radio button to EAT initially upon loading new data

    set(handles.uibuttongroup_fatType,'SelectedObject',...
        handles.radiobutton_EAT);



    % set the colormap radio button to gray initially

     set(handles.uibuttongroup_Colormap,'SelectedObject',...
         handles.radiobutton_Gray);
 
     colormap('gray');



    % enable boundaries button

    set(handles.pushbutton_FindBoundaries,'Enable','on');



    % disable tracing button until non-binary image type is chosen

     set(handles.togglebutton_TraceBoundaries,'Enable','off');

    

    % set up button down and button up handlers

    set(gcf,'WindowButtonDownFcn',@buttonDown);

    set(gcf,'WindowButtonUpFcn',@buttonUp);

    

    % set flag for loaded data to true

    BOOL_LOADED_DATA = 1;

    BOOL_TRACING_BOUNDARIES = 0;

    RESULTS_FILENAME = resultsFileName;

    BOOL_BUTTON_DOWN = 0;

end

% --- Executes on slider movement.
function slider_imageSlice_Callback(hObject, eventdata, handles)
% hObject    handle to slider_imageSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
vatviewerGlobalVars;



% as slider is moved, adjust which image is displayed - round to nearest

% integer and clamp to biggest values

maxval = get(handles.slider_imageSlice,'Max');

currpos = get(handles.slider_imageSlice,'Value');

currpos = round(currpos);

if currpos < 1

    currpos = 1;

end

if currpos > maxval

    currpos = maxval;

end

set(handles.slider_imageSlice,'Value',currpos);

disp(sprintf('slider value: %f',currpos));

imagesc(VOL_3D(:,:,uint8(currpos)),'Parent',handles.axes_image);



% set appropriate value in frame number label

% set(handles.text_frameNumber,'String',...
%     sprintf('Frame Number: %d',uint8(currpos)));



% --- Executes during object creation, after setting all properties.
function slider_imageSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_imageSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in uibuttongroup_fatType.
function uibuttongroup_fatType_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_fatType 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vatviewerGlobalVars;



if BOOL_LOADED_DATA

    

    % get current selection

    stringSelection = get(hObject,'String');

    

    % set the correct data and reload 

    switch stringSelection

        case 'E.A.T.'

            disp('EAT selected.');

            WHICH_TYPE = 'EAT_3D';

%             set(handles.pushbutton_FindBoundaries,'Enable','on');
% 
%             set(handles.togglebutton_TraceBoundaries,'Enable','off');

        case 'P.A.A.T.'

            disp('PAAT selected.');

            WHICH_TYPE = 'PAAT_3D';

%             set(handles.pushbutton_FindBoundaries,'Enable','on');
% 
%             set(handles.togglebutton_TraceBoundaries,'Enable','off');

       

        case 'S.C.A.T.'

            disp('SCAT selected.');

            WHICH_TYPE = 'SCAT_3D';

%             set(handles.pushbutton_FindBoundaries,'Enable','on');            
% 
%             set(handles.togglebutton_TraceBoundaries,'Enable','off');

      

        case 'V.A.T.'

            disp('VAT selected.');

            WHICH_TYPE = 'VAT_3D';

%             set(handles.pushbutton_FindBoundaries,'Enable','on');
% 
%             set(handles.togglebutton_TraceBoundaries,'Enable','off');

        case 'I.M.A.T.'

            disp('IMAT selected.');

            WHICH_TYPE = 'IMAT_3D';

%             set(handles.pushbutton_FindBoundaries,'Enable','on');
% 
%             set(handles.togglebutton_TraceBoundaries,'Enable','off');

         case 'C.A.T.'

            disp('CAT selected.');

            WHICH_TYPE = 'CAT_3D';

        otherwise

    end



    % now use the function to update the actual 3D data - does basically

    % same thing as above, but also sets data - could remove later???

    vatviewerSetTissueType();



    % now need to reset slider range and show correct data

    numSlices = size(VOL_3D,3); % 3rd dim is slices

    disp(sprintf('Number of slices: %d',numSlices));

    sliderhandle = handles.slider_imageSlice;

    set(sliderhandle,'Max',numSlices);

    set(sliderhandle,'Min',1);



    % keep current location of slider position unless it's out of bounds

    % for the new image set - if so, set to closest value

    valueToSet = get(sliderhandle,'Value');

    if (valueToSet > numSlices)

        valueToSet = floor(numSlices / 2);

    end

    

    % take the middle slice as the initial image to display

    imagesc(VOL_3D(:,:,valueToSet),'Parent',handles.axes_image);

    set(sliderhandle,'Value',valueToSet);

    

    % set appropriate value in frame number label

%     set(handles.text_frameNumber,'String',...
%         sprintf('Frame Number: %d',uint8(valueToSet)));



else

    errordlg('Load results data before selecting type!','Load Error');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  START   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton_FindBoundaries.
function pushbutton_FindBoundaries_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FindBoundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vatviewerGlobalVars;

% load the EAT variable from the results file
resultsFileName = 'subject12_i_results.mat';

% resultsFile = get(handles.resultsFileName,'FileName');
load(resultsFileName,'EAT3d');
load(resultsFileName,'CAT3d');

% pull out current frame of data
currSliceNum = get(handles.slider_imageSlice,'Value');
numSlices = size(EAT3d,3); % 3rd dim is slices

% disp(sprintf('Current frame for boundary tracing: %d',currSliceNum));



imageSlice_EAT = EAT3d(:,:,currSliceNum);
imageSlice_CAT = CAT3d(:,:,currSliceNum);



% convert image to true binary
binImageEAT = (imageSlice_EAT>0);
binImageCAT = (imageSlice_CAT>0);

binImageComposite=or(binImageEAT,binImageCAT);

clear imageSlice_EAT;
clear imageSlice_CAT;


% trace boundaries and overlay results
[B,L] = bwboundaries(binImageComposite,8,'holes');

hold on;


for k = 1:length(B)
    
     
   boundary = B{k};

   plot(boundary(:,2), boundary(:,1),'g','LineWidth',1);
    

end

hold off;








% create base of output filenames based on results filename
indexDot = find(resultsFileName == '.');
textOutName = resultsFileName(1,1:indexDot-1);
textOutName = strcat(textOutName,'_CGB_EAT_CAT_COMPOSITE.txt');



% open and write top part of file
fid = fopen(textOutName,'w');
fprintf(fid,'%d\n',numSlices);

% open up a figure window to display boundary pixels, use space bar to loop
% through each image
figure; 
hold on;

% loop through number of slices
for i=1:numSlices
    
    % write frame number
    fprintf(fid,'#%d\n',i-1);

    % pull out this frame of data, convert to pure binary, and write out
    % the boundary pixels as the contours
    imageSlice = EAT3d(:,:,i);
    binImage = (imageSlice>0);
    clear imageSlice;
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes on button press in togglebutton_TraceBoundaries.
function togglebutton_TraceBoundaries_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_TraceBoundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_TraceBoundaries


% --- Executes during object creation, after setting all properties.
function text_resultsFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_resultsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_frameNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_frameNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in uibuttongroup_Pushbutton.
function uibuttongroup_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to uibuttongroup_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uibuttongroup_Colormap.
function uibuttongroup_Colormap_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_Colormap 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vatviewerGlobalVars;



% set colormap based on value of radio button group selection

if BOOL_LOADED_DATA

    

    % get current selection

    stringSelection = get(hObject,'String');

    

    % set the correct data and reload 

    switch stringSelection

        case 'Parula'

            disp('Parula colormap selected.');

            colormap('Parula');

        case 'Hot'

            disp('Hot colormap selected.');

            colormap('Hot');

        case 'Gray'

            disp('Gray colormap selected.');

            colormap('Gray');

        case 'Bone'

            disp('Bone colormap selected.');

            colormap('Bone');

        otherwise

    end

else

    errordlg('Load results data before selecting a colormap!','Load Error');

end


% --- Executes on button press in CGP.
function CGP_Callback(hObject, eventdata, handles)
% hObject    handle to CGP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vatviewerGlobalVars;


% load the EAT variable from the results file
resultsFileName = 'subject01_i_results.mat';

% resultsFile = get(handles.resultsFileName,'FileName');
% resultsFile = 'subject01_i_results.mat';
load(resultsFileName,'EAT3d');
load(resultsFileName,'CAT3d');




% create base of output filenames based on results filename
indexDot = find(resultsFileName == '.');
textOutName = resultsFileName(1,1:indexDot-1);
textOutName = strcat(textOutName,'_CGB_EAT_CAT_COMPOSITE.txt');

% decide how many frames there are
numSlices = size(EAT3d,3); % 3rd dim is slices

% open and write top part of file
fid = fopen(textOutName,'w');
fprintf(fid,'%d\n',numSlices);

% open up a figure window to display boundary pixels, use space bar to loop
% through each image
figure; 
hold on;

% loop through number of slices
for i=1:numSlices
    
    % write frame number
    fprintf(fid,'#%d\n',i-1);

    % pull out this frame of data, convert to pure binary, and write out
    % the boundary pixels as the contours
    imageSlice = EAT3d(:,:,i);
    binImage = (imageSlice>0);
    clear imageSlice;
    [B,L] = bwboundaries(binImage,8,'holes');
    
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



% --- Executes on button press in Statistics.
function Statistics_Callback(hObject, eventdata, handles)
% hObject    handle to Statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


vatviewerGlobalVars;

% filename = get(handles.resultsFileName,'Filename');
filename = 'Eat.txt';

%
%I am reading the file's first line into a variable so that I know how wany
%contours there are to count
%



fileID = fopen(filename, 'r');



C = fscanf(fileID,'%d');
disp(C);
tline = fgetl(fileID);
n = 0;
num = 0;
h = zeros(0,3);
while ischar(tline)

    d = strfind(tline, '#');
    if (~isempty(d))
        disp('This is the slide number:');
        disp(tline);
        num = textscan(fileID,'%d',1);
        disp('This is the number of points'); 
        disp(num{1});
        if num{1} > 0
            test = textscan(fileID,'%f %f %f',num{1});
            M = test(1,1);
            N = test(1,2);
            O = test(1,3);
            total = horzcat(M{1,1},N{1,1},O{1,1});
            total = vertcat(total,total(1,:));
            disp(total);
            contour(n+1).number = num{1};
            contour(n+1).line = total;
            h = vertcat(h,total);
            n = n+1;
        else 
            num = textscan(fileID,'%d',1)
        end
    end
    tline = fgetl(fileID);
end
h = vertcat(h,zeros(0,3));

figure;
plot3(h(:,1),h(:,2),h(:,3),'.')
figure;

plot(contour(5).line(:,1),contour(5).line(:,2),'.');

fclose(fileID);
