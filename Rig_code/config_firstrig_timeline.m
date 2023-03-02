% Create a timeline object to be saved in hardware.mat
% Configured for Firstrig

% Instantiate the timeline object
timeline = hw.Timeline;

% Set sample rate
timeline.DaqSampleRate = 1000;

% Set up function for configuring inputs
daq_input = @(name, channelID, measurement, terminalConfig) ...
    struct('name', name,...
    'arrayColumn', -1,... % -1 is default indicating unused
    'daqChannelID', channelID,...
    'measurement', measurement,...
    'terminalConfig', terminalConfig, ...
    'axesScale', 1);

% Configure inputs
timeline.Inputs = [...
    daq_input('chrono', 'ai0', 'Voltage', 'SingleEnded')... % for reading back self timing wave
    daq_input('flipper', 'ai1', 'Voltage', 'SingleEnded'), ...
    daq_input('rotaryEncoder','ctr0','Position',[])
    ];

% Activate all defined inputs
timeline.UseInputs = {timeline.Inputs.name};

% Configure outputs (each output is a specialized object)

% (chrono - required timeline self-referential clock)
chronoOutput = hw.TLOutputChrono;
chronoOutput.DaqChannelID = 'port1/line0';

% Package the outputs 
timeline.Outputs = [chronoOutput];

% Configure live "oscilliscope"
timeline.LivePlot = true;

% Clear out all temporary variables
clearvars -except timeline

% save to "hardware" file
%%%%%%% ANDRADA: EDIT THIS TO BE LOCAL
save('\\zserver.cortexlab.net\Code\Rigging\config\LILRIG-TIMELINE\hardware.mat')
disp('Saved LILRIG-TIMELINE config file')







