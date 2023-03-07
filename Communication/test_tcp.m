server = tcpserver("0.0.0.0",30000)

data = read(server,server.NumBytesAvailable,"double");
plot(data);

write(server, data, "double")

write(server,"hello world","string")

read(server,server.NumBytesAvailable, "double");

read(server,server.NumBytesAvailable, "string")

% configureTerminator(server,"CR",10)

%% check if you can do two servers in one matlab
server2 = tcpserver("0.0.0.0",20000)
write(server2,"hello world","string")

write(server2, data, "double")

read(server2, 64, "double")

read(server2,12,"double")

writeline(server2, 'hello')