%% Test scripts 
%% Widefield preprocessing function
[U,Vrec,im_avg_color,frame_info] = AP_preprocess_widefield_hc('C:\Users\peterslab\Documents\MATLAB');

% svd reconstruction
example_fluorescence_blue = AP_svdFrameReconstruct(cell2mat(U(1)), cell2mat(Vrec(1)));
example_fluorescence_violet = AP_svdFrameReconstruct(cell2mat(U(2)), cell2mat(Vrec(2)));

AP_imscroll(example_fluorescence_blue);
axis image;

AP_imscroll(example_fluorescence_violet);
axis image;

%% - experiment split - works! - changed boundary to 20,000
[U,Vrec,im_avg_color,frame_info] = AP_preprocess_widefield_hc('C:\Users\peterslab\Documents\MATLAB\pause_video');

%% - check different ROIs
% centre
[U,Vrec,im_avg_color,frame_info] = AP_preprocess_widefield_hc('C:\Users\peterslab\Documents\MATLAB\centre_ROI');

%% Face camera preprocessing function
[timestamps, frame_num, flipper_signal] = AP_preprocess_face_camera("C:\Users\peterslab\Documents\MATLAB\face_camera\mmmgui_test\face.avi", 2);

%% Test wave save function
AM_save_h_file(trp_wave, 'sq_wave')
AM_save_h_file(trp_wave, 'trp_wave')

