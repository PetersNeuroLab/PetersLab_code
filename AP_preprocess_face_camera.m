function [timestamps, frame_num, flipper] = AP_preprocess_face_camera(embed_pixels, pin_num)
% [timestamps, frame_num, flipper] = AP_preprocess_face_camera(video_file, pin_num)
%
% Get embedded info from face camera videos

% %% Probably want to add how to find the video in the folder too! - once we have a set name for it
% video_file = dir(fullfile(video_path,'*.avi'));
% video_fn = fullfile(video_path,video_file.name);
%
% Embedded information: each component is 4 pixels (40 total)
% (from: https://www.flir.co.uk/support-center/iis/machine-vision/knowledge-base/embedding-frame-specific-data-into-the-first-n-pixels-of-an-image/)
% Timestamp
% Gain 
% Shutter
% Brightness
% Exposure
% White Balance
% Frame Counter
% Strobe pattern
% GPIO Pin State
% ROI position

% TO DO - update the indicies now that everything is embedded

% Requires embed_pixels which is 40 (4px x 10 items) x n frames

%% Embedded pixels

n_frames = size(embed_pixels,2);

%%  Timestamp

timestamp_pixels = embed_pixels(1:4,:);
bin_val_pixels = dec2bin(timestamp_pixels, 8);
bin_val_pixels = reshape(bin_val_pixels', 32, n_frames)';

% timestamp value that we can use is only in the first 20 bits
timestamp_bin_val = bin_val_pixels(:, 1:20);
% extract miliseconds
miliseconds = (bin2dec(timestamp_bin_val(:,8:20)))'/8000;
% extract seconds
seconds = (bin2dec(timestamp_bin_val(:,1:7)))';
% get total in seconds
seconds = seconds + miliseconds;

% make sure the seconds trace is continuous - it resets at 127
reset_counter_idx = find(diff([0 seconds])<0);
for i=1:length(reset_counter_idx)
    seconds(reset_counter_idx(i):end) = seconds(reset_counter_idx(i):end) + 128;
end % can replace this with a recursive function??? 

% report timestamp in seconds
timestamps = seconds';

%% Frame counter

frame_num_pixels = embed_pixels(25:28,:);
bin_val_pixels = dec2bin(frame_num_pixels, 8);
bin_val_pixels = reshape(bin_val_pixels', 32, n_frames)';
frame_num = bin2dec(bin_val_pixels);

%% GPIO pin states

pin_state_pixels = embed_pixels(33:36,:);
bin_val_pixels = dec2bin(pin_state_pixels, 8);
bin_val_pixels = reshape(bin_val_pixels', 32, n_frames)';
flipper = logical(str2num(bin_val_pixels(:, pin_num+1))); % pin numbering starts from 0 





