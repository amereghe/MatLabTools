x=0:0.1:10;
z1=sin(x);
z2=cos(x);
% first curve
y=ones(1,length(x));
fill3([x fliplr(x)],[y y],[z1 zeros(1,length(x))],'r','FaceAlpha',0.3);
hold on;
plot3(x,y,z1,'r');
hold on;
% second curve
y=2*ones(1,length(x));
fill3([x fliplr(x)],[y y],[z2 zeros(1,length(x))],'b','FaceAlpha',0.3);
plot3(x,y,z2,'b');
grid on;

