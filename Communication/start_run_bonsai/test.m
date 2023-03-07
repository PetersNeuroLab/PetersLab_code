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
oscreceiver.addListener(String('/msg'),osclistener);
oscreceiver.startListening();

%% run Bonsai workflow
workflowpath = 'C:\Users\peterslab\Documents\GitHub\PetersLab_code\Bonsai stuff\trial_test.bonsai';
local_runBonsaiWorkflow(workflowpath, [], [], 1)

%% send stop message
u = udpport("IPV4");
bonsai_oscsend(u,'/start',"localhost",30000,'i',45);

%% get message from Bonsai stopping
getlastmessage=osclistener.getMessageArgumentsAsDouble();
while(isempty(getlastmessage))
    getlastmessage=osclistener.getMessageArgumentsAsDouble();
end

% To close the port
oscreceiver.stopListening();
oscreceiver.close();
oscreceiver=[];
osclistener=[];

%% close Bonsai
system('taskkill /F /IM Bonsai.EXE')  