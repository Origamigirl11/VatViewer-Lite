function varargout = ECE_491(varargin)
% ECE_491 MATLAB code for ECE_491.fig
%      ECE_491, by itself, creates a new ECE_491 or raises the existing
%      singleton*.
%
%      H = ECE_491 returns the handle to a new ECE_491 or the handle to
%      the existing singleton*.
%
%      ECE_491('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECE_491.M with the given input arguments.
%
%      ECE_491('Property','Value',...) creates a new ECE_491 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECE_491_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECE_491_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ECE_491

% Last Modified by GUIDE v2.5 30-Jan-2017 10:02:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECE_491_OpeningFcn, ...
                   'gui_OutputFcn',  @ECE_491_OutputFcn, ...
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


% --- Executes just before ECE_491 is made visible.
function ECE_491_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECE_491 (see VARARGIN)

% Choose default command line output for ECE_491
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

vatviewerGlobalVars;


% UIWAIT makes ECE_491 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ECE_491_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
       
%LOAD IMAGE BUTTON
        
%--------------------------------------------------------------------------       



% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vatviewerGlobalVars;

  [filename pathname]=uigetfile('*.mat', 'File Selector');
  image=strcat(pathname,filename);
  Filename=image;
  load(Filename);
  axes(handles.axes1)
  h = msgbox('Image is Loaded. Choose a Fat Type');
  
  
  
  
%--------------------------------------------------------------------------
       
%E.A.T.
        
%--------------------------------------------------------------------------       


% --- Executes on button press in eat.
function eat_Callback(hObject, eventdata, handles)
% hObject    handle to eat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eat


vatviewerGlobalVars;


load (Filename, 'EAT3d')
axes(handles.axes1)
%imshow(EAT3d(:,:,12))
imshow(EAT3d(:,:,sliderhandle))


%--------------------------------------------------------------------------
       
%I.M.A.T.
        
%--------------------------------------------------------------------------       



% --- Executes on button press in imat.
function imat_Callback(hObject, eventdata, handles)
% hObject    handle to imat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imat

vatviewerGlobalVars;


load (Filename, 'IMAT3d')
axes(handles.axes1)
imshow(IMAT3d(:,:,12))

%--------------------------------------------------------------------------
       
%P.A.A.T.
        
%--------------------------------------------------------------------------       


% --- Executes on button press in paat.
function paat_Callback(hObject, eventdata, handles)
% hObject    handle to paat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of paat

vatviewerGlobalVars;


load (Filename, 'PAAT3d')
axes(handles.axes1)
imshow(PAAT3d(:,:,12))



%--------------------------------------------------------------------------
       
%S.C.A.T.
        
%--------------------------------------------------------------------------       


% --- Executes on button press in scat.
function scat_Callback(hObject, eventdata, handles)
% hObject    handle to scat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scat

vatviewerGlobalVars;


load (Filename, 'SCAT3d')
axes(handles.axes1)
imshow(SCAT3d(:,:,4)) % instead of hardocding the nuber I should call a function. 

%--------------------------------------------------------------------------
       
%V.A.T.
        
%--------------------------------------------------------------------------       


% --- Executes on button press in vat.
function vat_Callback(hObject, eventdata, handles)
% hObject    handle to vat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vat

vatviewerGlobalVars;


load (Filename, 'EAT3d')
axes(handles.axes1)
imshow(VAT3d(:,:,12))


%--------------------------------------------------------------------------
       
%SLIDER
        
%--------------------------------------------------------------------------       


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

vatviewerGlobalVars;

 numSlices = size(VOL_3D,3); % 3rd dim is slices

    sliderhandle = handles.slider1;

    set(sliderhandle,'Max',numSlices);

    set(sliderhandle,'Min',1);

    

    % take the middle slice as the initial image to display

    middleSlice = floor(numSlices / 2);

    imagesc(VOL_3D(:,:,middleSlice),'Parent',handles.axes_image);

    set(sliderhandle,'Value',middleSlice);
  


maxval = get(handles.slider1,'Max');

currpos = get(handles.slider1,'Value');

currpos = round(currpos);

if currpos < 1

    currpos = 1;

end

if currpos > maxval

    currpos = maxval;

end

set(handles.slider1,'Value',currpos);

disp(sprintf('slider value: %f',currpos));

imagesc(VOL_3D(:,:,uint8(currpos)),'Parent',handles.axes1);



% set appropriate value in frame number label

set(handles.text_frameNumber,'String',...
    sprintf('Frame Number: %d',uint8(currpos)));


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



