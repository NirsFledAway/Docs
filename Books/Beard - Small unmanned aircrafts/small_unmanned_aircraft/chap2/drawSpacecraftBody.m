function handle = drawSpacecraftBody(u)
persistent spacecraft_handle; 
pn = u(1);
pe = u(2);
pd = u(3);
phi = u(4);
theta = u(5);
psi = u(6);
% define points on spacecraft in local NED
NED=spacecraftPoints;
 % rotate spacecraft by phi, theta, psi
 NED = rotate(NED,phi,theta,psi);
 % translate spacecraft to [pn; pe; pd]
 NED = translate(NED,pn,pe,pd);
 % transform vertices from NED to XYZ
 R=[0, 1, 0;
     1, 0, 0;
     0, 0, -1];
 XYZ = R*NED;
 % plot spacecraft
 if isempty(spacecraft_handle),
   spacecraft_handle = plot3(XYZ(1,:),XYZ(2,:),XYZ(3,:), 'eraseMode',  'normal');
   grid on;
 else
   set(spacecraft_handle,'XData',XYZ(1,:),'YData',XYZ(2,:),'ZData',XYZ(3,:));
   drawnow
 end