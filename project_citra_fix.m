function varargout = project_citra_fix(varargin)
% PROJECT_CITRA_FIX MATLAB code for project_citra_fix.fig
%      PROJECT_CITRA_FIX, by itself, creates a new PROJECT_CITRA_FIX or raises the existing
%      singleton*.
%
%      H = PROJECT_CITRA_FIX returns the handle to a new PROJECT_CITRA_FIX or the handle to
%      the existing singleton*.
%
%      PROJECT_CITRA_FIX('CALLBAguCK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT_CITRA_FIX.M with the given input arguments.
%
%      PROJECT_CITRA_FIX('Property','Value',...) creates a new PROJECT_CITRA_FIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_citra_fix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_citra_fix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project_citra_fix

% Last Modified by GUIDE v2.5 29-Nov-2023 14:32:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_citra_fix_OpeningFcn, ...
                   'gui_OutputFcn',  @project_citra_fix_OutputFcn, ...
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


% --- Executes just before project_citra_fix is made visible.
function project_citra_fix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project_citra_fix (see VARARGIN)

% Choose default command line output for project_citra_fix
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
ah = axes('Units','normalized', 'Position', [0 0 1 1]);
bg = imread('background.png'); imagesc(bg);
set(ah, 'handleVisibility', 'off', 'visible', 'off')



% UIWAIT makes project_citra_fix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_citra_fix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global G;
[nama , alamat] = uigetfile({'*.jpg';'*.bmp';'*.png';'*.tif'},'Browse Image'); %mengambil data
I = imread([alamat,nama]); %membaca data yg dipilih
handles.image=I; %gambar terpilih disimpan ke I
guidata(hObject, handles); %mengarahkan gcbo ke objek yg fungsinya sedang di eksekusi
axes(handles.axes1); %akses akses1
imshow(I,[]); %menampilkan gambar
G=I; %menyimpan data I ke G, jd isinya sama G dg I, nanti G yang berubah karena image processingnya
axes(handles.axes3); %akses axes3 buat histogram asal
histogramRGB(G); %nampil fungsi histogramRGB

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
[nama, alamat] = uiputfile({'*.png','PNG (*.PNG)';'*.jpg','JPG (*.jpg)'},'Save Image');
imwrite(G,fullfile(alamat,nama));
guidata(hObject, handles);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
global I;
citra=handles.image; 
axes(handles.axes2);
cla;
imshow(citra); %membuat citra asli blm terkena filter tetap ada
axes(handles.axes4);
cla reset;
G=I;

% --- Executes on slider movement.
function contrass_Callback(hObject, eventdata, handles)
% hObject    handle to contrass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global G;
valueKon=get(handles.contrass,'Value'); %ambil nilai kontras
valueCe=get(handles.brightness,'Value'); %ambil nilai cerah
valueBlur=get(handles.blurSlider,'Value');
valueSharp=get(handles.sharpness,'Value');
set(handles.cont_txt,'String',valueKon); %tulis nilai kontras
valueSalt=get(handles.salt,'Value');
citra=handles.image; %citra asli
cerah=citra+valueCe; %operasi kecerahan
noiseSalt = imnoise(cerah,'salt & pepper', valueSalt); %fungsi noise dg salt & pepper
blurImage = blurring(noiseSalt, valueBlur); %panggil fungsi blurring.m
sharpen=imsharpen(blurImage,'Radius',2,'Amount',valueSharp); %Amount: how much sharpening you’re doing, ambil dr valueSharp
                        %Radius: the reach of the filter, in terms of how far from an edge the sharpening extends
                        %2 adl Nilai yg mengontrol ukuran wilayah di sekitar piksel tepi yang dipengaruhi oleh penajaman
                        %Standard deviation of the Gaussian lowpass filter=1
kontras=valueKon*sharpen; %operasi kontras, jd walaupun valueCe bernilai 0, kontras dinaikkan akan tetap memberikan efek, 
                        %tp kalo valueKon 0 maka kecerahan ditambah berapapun akan gelap
G=kontras; %tampilin citra setelah kena kontras
axes(handles.axes2); %tampilin di axes2
guidata(hObject, handles); 
imshow(G,[]); %menampilkan G dengan array agar dapat dilakukan perubahan efek scr langsung setelah citra terakhir
axes(handles.axes4); 
histogramRGB(G);

% --- Executes during object creation, after setting all properties.
function contrass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
valueK=get(handles.contrass,'Value');
valueC=get(handles.brightness,'Value');
valueSharp=get(handles.sharpness,'Value');
valueSalt=get(handles.salt,'Value');
valueBlur=get(handles.blurSlider,'Value');
set(handles.bright_txt,'String',valueC);
citra=handles.image;
noiseSalt = imnoise(citra,'salt & pepper', valueSalt); %fungsi noise dg salt & pepper
kontras=valueK*(noiseSalt+valueC); %operasi kontras, jd kalo valueK 0 maka kontras bernilai 0
blurImage = blurring(kontras, valueBlur); %panggil fungsi blurring.m
sharpen=imsharpen(blurImage,'Radius',2,'Amount',valueSharp); %Amount: how much sharpening you’re doing, ambil dr valueSharp
                        %Radius: the reach of the filter, in terms of how far from an edge the sharpening extends
                        %2 adl Nilai yg mengontrol ukuran wilayah di sekitar piksel tepi yang dipengaruhi oleh penajaman
                        %Standard deviation of the Gaussian lowpass filter=1
cerah=sharpen+valueC; %berhub dg koding kontras, jd ini jika nilai kontras ada maka penambahan cerah dilihat dr kontrasnya
G=cerah;
axes(handles.axes2);
guidata(hObject, handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G);

% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, ~, ~)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in greyscale.
function greyscale_Callback(hObject, eventdata, handles)
% hObject    handle to greyscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2); %akses axes2
G = rgb2gray(G); %fungsi untuk merubah jd grayscale
guidata(hObject,handles); 
imshow(G,[]); %menampilkan G dengan array agar dapat dilakukan perubahan efek scr langsung setelah citra terakhir ditampilkan di axes2
axes(handles.axes4); %akses axes4
histogramRGB(G); %menampilkan histogram citra G


% --- Executes on button press in binner.
function binner_Callback(hObject, eventdata, handles)
% hObject    handle to binner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2); %akses axes2
G = im2bw(G); %fungsi untuk merubah jd binner
guidata(hObject,handles);
imshow(G,[]); %menampilkan G dg array agar dapat dilakukan perubahan efek scr langsung setelah citra terakhir ditampilkan di axes2
axes(handles.axes4); %akses axes4
histogramRGB(G); %menampilkan histogram citra G


% --- Executes on button press in negatif.
function negatif_Callback(hObject, eventdata, handles)
% hObject    hanclcdle to negatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2);
G = imcomplement(G); %fungsi citra negatif di matlab
guidata(hObject,handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G);

% --- Executes on button press in red.
function red_Callback(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2);
red = G(:,:,1); % Red channel
% Create an all black channel.
var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_red = cat(3, red, var, var);
guidata(hObject,handles);
imshow(just_red);
axes(handles.axes4);
histogram(G(:),256,'FaceColor','r','EdgeColor','r')

% --- Executes on button press in green.
function green_Callback(hObject, eventdata, handles)
% hObject    handle to green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2);
green = G(:,:,2); % Green channel
% Create an all black channel.
var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_green = cat(3, var, green, var);
guidata(hObject,handles);
imshow(just_green);
axes(handles.axes4);
%histogramRGB(G);
histogram(G(:),256,'FaceColor','g','EdgeColor','g')

% --- Executes on button press in blue.
function blue_Callback(hObject, eventdata, handles)
% hObject    handle to blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes2);
blue = G(:,:,3); % Blue channel
% Create an all black channel.
var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_blue = cat(3, var, var, blue);
guidata(hObject,handles);
imshow(just_blue);
axes(handles.axes4);
%histogramRGB(G);
histogram(G(:),256,'FaceColor','b','EdgeColor','b')

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in edge.
function edge_Callback(hObject, eventdata, handles)
% hObject    handle to edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G; 
axes(handles.axes2);
x = get(handles.popupmenu2,'Value'); %ambil nilai x dr popupmenu (pilihan ke berapa)
switch x
    case 1 %pilihan 1 untuk ubah ke prewitt
        imagedouble=double(rgb2gray(G)); %G dijadiin grayscale kemudian dijadiin double untuk perhitungan deteksi tepi
        G=edge(imagedouble,'prewitt'); %fungsi deteksi tepi dengan prewitt, melakukan perhitungan fungsi tepi dg imagedouble
    case 2
        imagedouble=double(rgb2gray(G));
        G=edge(imagedouble,'sobel');
    case 3
        imagedouble=double(rgb2gray(G));
        G=edge(imagedouble,'canny');
end
guidata(hObject,handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G);

function cont_txt_Callback(hObject, eventdata, handles)
% hObject    handle to cont_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cont_txt as text
%        str2double(get(hObject,'String')) returns contents of cont_txt as a double


% --- Executes during object creation, after setting all properties.
function cont_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cont_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bright_txt_Callback(hObject, eventdata, handles)
% hObject    handle to bright_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bright_txt as text
%        str2double(get(hObject,'String')) returns contents of bright_txt as a double


% --- Executes during object creation, after setting all properties.
function bright_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bright_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sharpness_Callback(hObject, eventdata, handles)
% hObject    handle to sharpness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global G;
valueSharp=get(handles.sharpness,'Value');
set(handles.sharp_txt,'String',valueSharp);
valueKon=get(handles.contrass,'Value'); %ambil nilai kontras
valueCe=get(handles.brightness,'Value'); %ambil nilai cerah
valueBlur=get(handles.blurSlider,'Value');
valueSalt=get(handles.salt,'Value');
citra=handles.image; %citra asli
cerah=citra+valueCe; %operasi kecerahan
blurImage = blurring(cerah, valueBlur); %panggil fungsi blurring.m
kontras=valueKon*blurImage; %operasi kontras, jd walaupun valueCe bernilai 0, kontras dinaikkan akan tetap memberikan efek, 
                        %tp kalo valueKon 0 maka kecerahan ditambah berapapun akan gelap
sharpen=imsharpen(kontras,'Radius',2,'Amount',valueSharp); %Amount: how much sharpening you’re doing, ambil dr valueSharp
                        %Radius: the reach of the filter, in terms of how far from an edge the sharpening extends
                        %2 adl Nilai yg mengontrol ukuran wilayah di sekitar piksel tepi yang dipengaruhi oleh penajaman
                        %Standard deviation of the Gaussian lowpass filter=1
noiseSalt = imnoise(sharpen,'salt & pepper', valueSalt); %fungsi noise dg salt & pepper
G=noiseSalt;
axes(handles.axes2);
guidata(hObject, handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G); %panggil fungsi histogram

% --- Executes during object creation, after setting all properties.
function sharpness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sharpness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sharp_txt_Callback(hObject, eventdata, handles)
% hObject    handle to sharp_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sharp_txt as text
%        str2double(get(hObject,'String')) returns contents of sharp_txt as a double


% --- Executes during object creation, after setting all properties.
function sharp_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sharp_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gray_txt_Callback(hObject, eventdata, handles)
% hObject    handle to gray_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gray_txt as text
%        str2double(get(hObject,'String')) returns contents of gray_txt as a double


% --- Executes during object creation, after setting all properties.
function gray_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gray_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function salt_Callback(hObject, eventdata, handles)
% hObject    handle to salt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
citra=handles.image; 
axes(handles.axes2);
valueSharp=get(handles.sharpness,'Value');
valueSalt=get(handles.salt,'Value');
valueK=get(handles.contrass,'Value');
valueC=get(handles.brightness,'Value');
noiseSalt = imnoise(citra,'salt & pepper', valueSalt); %fungsi noise dg salt & pepper
kontras=valueK*(noiseSalt+valueC); %operasi kontras, jd kalo valueK 0 maka kontras bernilai 0
cerah=kontras+valueC; %berhub dg koding kontras, jd ini jika nilai kontras ada maka penambahan cerah dilihat dr kontrasnya
sharpen=imsharpen(cerah,'Radius',2,'Amount',valueSharp); %Amount: how much sharpening you’re doing, ambil dr valueSharp
                        %Radius: the reach of the filter, in terms of how far from an edge the sharpening extends
                        %2 adl Nilai yg mengontrol ukuran wilayah di sekitar piksel tepi yang dipengaruhi oleh penajaman
                        %Standard deviation of the Gaussian lowpass filter=1
G = sharpen;
set(handles.salt_txt,'String',valueSalt);
guidata(hObject,handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function salt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to salt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function salt_txt_Callback(hObject, eventdata, handles)
% hObject    handle to salt_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of salt_txt as text
%        str2double(get(hObject,'String')) returns contents of salt_txt as a double


% --- Executes during object creation, after setting all properties.
function salt_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to salt_txt (see GCBO)g
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function blurSlider_Callback(hObject, eventdata, handles)
% hObject    handle to blurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
citra=handles.image; 
axes(handles.axes2);
valueBlur=get(handles.blurSlider,'Value');
valueSharp=get(handles.sharpness,'Value');
set(handles.blur_txt,'String',valueBlur);
valueSalt=get(handles.salt,'Value');
valueK=get(handles.contrass,'Value');
valueC=get(handles.brightness,'Value');
noiseSalt = imnoise(citra,'salt & pepper', valueSalt); %fungsi noise dg salt & pepper
kontras=valueK*(noiseSalt+valueC); %operasi kontras, jd kalo valueK 0 maka kontras bernilai 0
cerah=kontras+valueC; %berhub dg koding kontras, jd ini jika nilai kontras ada maka penambahan cerah dilihat dr kontrasnya
sharpen=imsharpen(cerah,'Radius',2,'Amount',valueSharp); %Amount: how much sharpening you’re doing, ambil dr valueSharp
                        %Radius: the reach of the filter, in terms of how far from an edge the sharpening extends
                        %2 adl Nilai yg mengontrol ukuran wilayah di sekitar piksel tepi yang dipengaruhi oleh penajaman
                        %Standard deviation of the Gaussian lowpass filter=1
blurImage = blurring(sharpen, valueBlur); %panggil fungsi blurring.m
G = blurImage;
guidata(hObject,handles);
imshow(G,[]);
axes(handles.axes4);
histogramRGB(G);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function blurSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function blur_txt_Callback(hObject, eventdata, handles)
% hObject    handle to blur_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blur_txt as text
%        str2double(get(hObject,'String')) returns contents of blur_txt as a double


% --- Executes during object creation, after setting all properties.
function blur_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blur_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
