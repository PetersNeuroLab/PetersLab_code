protocol = 'trial_test';
name = 'MissMouse0801';

server = tcpserver("0.0.0.0",10000);

s = struct('mouse', name, 'protocol', protocol);
encode_s = jsonencode(s);
write(server,encode_s,'string');

%% send start message
write(server,'start','string');

%% send stop message
write(server,'stop','string');
