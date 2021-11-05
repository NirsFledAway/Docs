function drawAircraftt(uu)
    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);           
    u        = uu(4);       
    v        = uu(5);       
    w        = uu(6);       
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    p        = uu(10);       % roll rate
    q        = uu(11);       % pitch rate     
    r        = uu(12);       % yaw rate    
    t        = uu(13);       % time

    % define persistent variables 
    persistent aircraft_handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        [Vertices, Faces, facecolors] = defineAircraft;
        aircraft_handle = drawAircraftBody(Vertices,Faces,facecolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');
        title('Aircraft')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        axis([-500,500,-500,500,-500,500]);
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawAircraftBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           aircraft_handle);
    end
end

  
%=======================================================================
% drawAircraft
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawAircraftBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle,mode)

  V = rotate(V', phi, theta, psi);  % rotate Aircraft

  V = translate(V, pn, pe, pd);  % translate Aircraft
  % transform vertices from NED to XYZ (for matlab rendering)
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V'*R;
  if isempty(handle)
      handle = patch('Vertices', V, 'Faces', F,...
                     'FaceVertexCData',patchcolors,...
                     'FaceColor','flat',...
                     'EraseMode', mode);
       grid on;
  else
    set(handle,'Vertices',V,'Faces',F);
    drawnow
  end
end

%%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi)
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_roll*R_pitch*R_yaw;
  % rotate vertices
  XYZ = R*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
  XYZ = XYZ + repmat([pn;pe;pd],1,size(XYZ,2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define aircraft vertices and faces
function [V,F,facecolors] = defineAircraft()

% Define the vertices (physical location of vertices
V = [...
    75, 0, 0;...       % pt 1
    50, 25, -25;...    % pt 2
    50, -25, -25;...   % pt 3
    50, -25, 25;...    % pt 4
    50, 25, 25;...     % pt 5
    -225, 0, 0;...      % pt 6
    0, 125, 0;...       % pt 7
    -50, 125, 0;...      % pt 8
    -50, -125, 0;...     % pt 9
    0, -125, 0;...      % pt 10
    -187.5, 75, 0;...   % pt 11
    -225, 75, 0;...    % pt 12
    -225, -75, 0;...   % pt 13
    -187.5, -75, 0;...  % pt 14
    -187.5, 0, 0;...     % pt 15
    -225, 0, -62.5;...  % pt 16
    ];

% define faces as a list of vertices numbered above
  F = [...
        1, 1, 2, 5;...  % nose right
        1, 1, 3, 4;...  % nose left
        1, 1, 2, 3;...  % nose upper
        1, 1, 4, 5;...  % nose bottom
        2, 5, 6, 6;...  % fuselage right
        3, 4, 6, 6;...  % fuselage left
        2, 3, 6, 6;...  % fuselage upper
        4, 5, 6, 6;...  % fuselage bottom
        7, 8, 9, 10;...  % wing
        11, 12, 13, 14;...  % horizontal tail
        6, 15, 16, 6;...  % vertical tail
        ];

% define colors for each face    
  myred = [1, 0, 0];
  mygreen = [0, 1, 0];
  myblue = [0, 0, 1];
  myyellow = [1, 1, 0];
  mycyan = [0, 1, 1];

  facecolors = [...
    myyellow;...    % nose right
    myyellow;...    % nose left
    myyellow;...    % nose upper
    myyellow;...    % nose bottom
    myblue;...      % fuselage right
    myblue;...      % fuselage left
    myblue;...      % fuselage upper
    myred;...      % fuselage bottom
    mygreen;...     % wing
    mygreen;...     % horizontal tail
    myblue;...      % vertical tail
    ];
end
  