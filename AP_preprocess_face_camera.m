function [timestamps, frame_num, flipper_signal] = AP_preprocess_face_camera(video_fn, pin_num)
% [timestamps, frame_num, flipper_signal] = AP_preprocess_face_camera(video_file, pin_num)
%
% Get embedded info from face camera videos

% %% Probably want to add how to find the video in the folder too! - once we have a set name for it
% video_file = dir(fullfile(video_path,'*.avi'));
% video_fn = fullfile(video_path,video_file.name);

%% Read Video
video_object = VideoReader(video_fn);
video = read(video_object); % last dim is frame number: (h,w,channel,frame_num)
n_frames = size(video,4);

%% Extract embedded pixels
% get the first row, 12 pixels, from all frames + change order so it's not
% 4D for no reason + get rid of extra channels
% I think camera by default produces RGB channels - there's an extra dim of
% length 3 so I'll just pick one, they're all the same (I checked)
embed_pixels = permute(video(1,1:12,1,:), [2,4,1,3]);

%%  Get timestamp from the first 4 pixels
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

% start from 0 instead of random value 
timestamps = seconds - seconds(1);

%% FrameCounter
frame_num_pixels = embed_pixels(5:8,:);
bin_val_pixels = dec2bin(frame_num_pixels, 8);
bin_val_pixels = reshape(bin_val_pixels', 32, n_frames)';
frame_num = bin2dec(bin_val_pixels);
frame_num = frame_num - frame_num(1) + 1;
% can check length of this against the big frame number + can check if
% consecutive

%% GPIO Pin State
pin_state_pixels = embed_pixels(9:end,:);
bin_val_pixels = dec2bin(pin_state_pixels, 8);
bin_val_pixels = reshape(bin_val_pixels', 32, length(frame_num))';
flipper_signal = bin_val_pixels(:, pin_num+1); % pin numbering starts from 0 

