%% start servers for all connected things
server_mc = tcpserver("0.0.0.0",50001);
server_timelight = tcpserver("0.0.0.0",50002);
server_face_camera = tcpserver("0.0.0.0",50003);
u_bonsai = udpport("IPV4");

%% setup listening to Bonsai workflow
cd('C:\Users\peterslab\Documents\start_run_stop_bonsai\java_stuff')

% Load the jar file
javaaddpath('javaosctomatlab.jar');

% go back to code folder
cd('C:\Users\peterslab\Documents\start_run_stop_bonsai')

% To initialize:
% javaaddpath(schedule.javaoscpath);
import com.illposed.osc.*;
import java.lang.String;

% To read:
oscport= 20000;
oscreceiver = OSCPortIn(oscport);
osclistener = MatlabOSCListener();
oscreceiver.addListener(String('/stop'),osclistener);
oscreceiver.startListening();

%% init stuff
save_path = 'C:\Users\peterslab\Documents';
all_workflows = 'C:\Users\peterslab\Documents\GitHub\PetersLab_code\Bonsai stuff';

while(1)
    %% wait for file info from mc
    waitfor(server_mc, 'NumBytesAvailable')
    exp_data = read(server_mc, server_mc.NumBytesAvailable,"string");

    % decode json
    data_struct = jsondecode(exp_data);

    % make mouse dir
    this_save_path = fullfile(save_path,data_struct.mouse);
    mkdir(this_save_path);

    % get paths for files
    workflowpath = fullfile(all_workflows, [data_struct.protocol '.bonsai']);
    filename = fullfile(this_save_path, 'test.csv');

    %% send Start message and start bonsai

    % send to timeline and face camera
    write(server_timelight,  'start', 'string');
    write(server_face_camera,  'start', 'string');

    % run Bonsai
    local_runBonsaiWorkflow(workflowpath, {'FileName', filename}, [], 1)

    %% get Stop message and send to all
    msg_stop = [];
    while msg_stop~='stop'
        waitfor(server_mc, 'NumBytesAvailable')
        msg_stop = read(server_mc, server_mc.NumBytesAvailable,"string");
    end

    % send stop to bonsai
    bonsai_oscsend(u,'/stop',"localhost",50004,'i',45);

    % get message from Bonsai stopping
    getlastmessage=osclistener.getMessageArgumentsAsDouble();
    while(isempty(getlastmessage))
        getlastmessage=osclistener.getMessageArgumentsAsDouble();
    end

    % send stop to timeline and face cam
    write(server_timelight, msg_start, 'string');
    write(server_face_camera, msg_start, 'string');

    % close Bonsai
    system('taskkill /F /IM Bonsai.EXE');
    system('taskkill /F /IM OpenConsole.EXE');
end

%% cleanup 
% To close the port
oscreceiver.stopListening();
oscreceiver.close();
oscreceiver=[];
osclistener=[];


