%% setup servers
server_stim = tcpserver("0.0.0.0",50001);
server_timelight = tcpserver("0.0.0.0",50002);
server_face_camera = tcpserver("0.0.0.0",50003);

%% send mouse and protocol info
protocol = 'trial_test';
name = 'MissMouse0801';

waitfor(server_stim, 'Connected', 1)
s = struct('mouse', name, 'protocol', protocol);
encode_s = jsonencode(s);
write(server_stim,encode_s,'string');

%% send start message
write(server_timelight,  'start', 'string');
write(server_face_camera,  'start', 'string');

%% send stop message
write(server_stim,'stop','string');
write(server_timelight, 'stop', 'string');
write(server_face_camera, 'stop', 'string');