protocol = 'trial_test';
name = 'MissMouse0801';

client = tcpclient("163.1.249.37",50001);

s = struct('mouse', name, 'protocol', protocol);
encode_s = jsonencode(s);
write(client,encode_s,'string');

%% send start message
write(client,'start','string');

%% send stop message
write(client,'stop','string');
