function [sys,x0,str,ts,simStateCompliance] = mav_dynamics(t,x,u,flag,MAV)

switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(MAV);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1
    sys=mdlDerivatives(t,x,u,MAV);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3
    sys=mdlOutputs(t,x);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(MAV)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 13;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 12;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [...
    MAV.pn0;...
    MAV.pe0;...
    MAV.pd0;...
    MAV.u0;...
    MAV.v0;...
    MAV.w0;...
    MAV.e0;...
    MAV.e1;...
    MAV.e2;...
    MAV.e3;...
    MAV.p0;...
    MAV.q0;...
    MAV.r0;...
    ];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,uu, MAV)

%   Earth coordinates
    pn    = x(1);
    pe    = x(2);
    pd    = x(3);
%   speed in 'b' coordinates
    u     = x(4);
    v     = x(5);
    w     = x(6);
%   position quaternions
    e0    = x(7);
    e1    = x(8);
    e2    = x(9);
    e3    = x(10);
%   angular speeds
    p     = x(11);  % крен
    q     = x(12);  % тангаж
    r     = x(13);  % рыскание
%   inputs
    fx    = uu(1);  
    fy    = uu(2);
    fz    = uu(3);
    ell   = uu(4);
    m     = uu(5);
    n     = uu(6);
    
%   p. 226
    pndot = (e1^2 + e0^2 - e2^2 - e3^2)*u + 2*(e1*e2 - e3*e0)*v + 2*(e1*e3+e2*e0)*w;
    
    pedot = 2*(e1*e3-e2*e0)*u + (e2^2+e0^2-e1^2-e3^2)*v + 2*(e2*e3-e1*e0)*w;
    
    pddot = 2*(e1*e3-e2*e0)*u + 2*(e2*e3+e1*e0)*v + (e3^2+e0^2-e1^2-e2^2)*w;
    
    mass = MAV.mass;
    udot = (r*v - q*w) + (1/mass) * fx;
    
    vdot = (p*w - r*u) + (1/mass) * fy;
    
    wdot = (q*u - p*v) + (1/mass) * fz;
       
    e0dot = 0.5 * (-p*e1 - q*e2 - r*e3);
    e1dot = 0.5 * (p*e0 + r*e2 - q*e3);
    e2dot = 0.5 * (q*e0 - r*e1 + p*e3);
    e3dot = 0.5 * (r*e0 + q*e1 - p*e2);

    gamma1 = MAV.Gamma1
    gamma2 = MAV.Gamma2
    gamma3 = MAV.Gamma3
    gamma4 = MAV.Gamma4
    gamma5 = MAV.Gamma5
    gamma6 = MAV.Gamma6
    gamma7 = MAV.Gamma7
    gamma8 = MAV.Gamma8
    Jy = MAV.Jy
        
    pdot = (gamma1*p*q - gamma2*q*r) + (gamma3*ell + gamma4*n);
    
    qdot = (gamma5*p*r - gamma6*(p^2-r^2)) + (1/Jy)*m;
    rdot = (gamma7*p*q - gamma1*q*r) + (gamma4*ell + gamma8*n);
        

sys = [pndot; pedot; pddot; udot; vdot; wdot; e0dot; e1dot; e2dot; e3dot; pdot; qdot; rdot];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x)
    y = [...
        ];
sys = y;

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
