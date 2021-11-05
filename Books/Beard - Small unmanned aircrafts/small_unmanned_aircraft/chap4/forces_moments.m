% forces_moments.m
%   Computes the forces and moments acting on the airframe. 
%
%   Output is
%       F     - forces
%       M     - moments
%       Va    - airspeed
%       alpha - angle of attack
%       beta  - sideslip angle
%       wind  - wind vector in the inertial frame
%

function out = forces_moments(x, delta, wind, P)
    % relabel the inputs
    pn      = x(1);
    pe      = x(2);
    pd      = x(3);
    u       = x(4);
    v       = x(5);
    w       = x(6);
    phi     = x(7);
    theta   = x(8);
    psi     = x(9);
    p       = x(10);
    q       = x(11);
    r       = x(12);
    delta_e = delta(1);
    delta_a = delta(2);
    delta_r = delta(3);
    delta_t = delta(4);
    w_ns    = wind(1); % steady wind - North
    w_es    = wind(2); % steady wind - East
    w_ds    = wind(3); % steady wind - Down
    u_wg    = wind(4); % gust along body x-axis
    v_wg    = wind(5); % gust along body y-axis    
    w_wg    = wind(6); % gust along body z-axis
    
    
   w_v = [w_ns; w_es; w_ds];
   w_b = rotate(w_v, phi, theta, psi);
  
    
    % compute wind data in NED
    w_n = w_b(1) + u_wg;
    w_e = w_b(2) + v_wg;
    w_d = w_b(3) + w_wg;
    
    
    v_ab = [u-w_n; v-w_e; w-w_d];
    
    % compute air data
    Va = sqrt(v_ab(1)^2 + v_ab(2)^2 + v_ab(3)^2);
    alpha = atan(v_ab(3)/ v_ab(1));
    beta = asin(v_ab(2)/Va);
    
    vals = [Va; alpha; beta];
    %display(x);
    display(delta);
    display(vals);
    
    % gravity forces
    f_g_x = -P.mass * P.gravity * sin(theta);
    f_g_y = P.mass * P.gravity * cos(theta) * sin(phi);
    f_g_z = P.mass * P.gravity * cos(theta) * cos(phi);
    f_g = [f_g_x; f_g_y; f_g_z];
    
    
    % stability coefficients
    c_x_alpha = -P.C_D_alpha * cos(alpha) + P.C_L_alpha * sin(alpha);
    c_x_q_alpha = -P.C_D_q * cos(alpha) + P.C_L_q * sin(alpha);
    c_x_delta_e_alpha = -P.C_D_delta_e * cos(alpha) + P.C_L_delta_e * sin(alpha);
    c_z_alpha = -P.C_D_alpha * sin(alpha) - P.C_L_delta_e*cos(alpha);
    c_z_q_alpha = -P.C_D_q * sin(alpha) - P.C_L_q * cos(alpha);
    c_z_delta_e_alpha = -P.C_D_delta_e * sin(alpha) - P.C_L_delta_e * cos(alpha);
    
    %aerodynamics forces
    tmp = 1/2*P.rho*Va^2*P.S_wing;
    f_a_x = c_x_alpha + c_x_q_alpha*P.c/(2*Va)*q + c_x_delta_e_alpha * delta_e;
    f_a_y = P.C_Y_0 + P.C_Y_beta * beta + P.C_Y_p *P.b/(2*Va)*p + P.C_Y_r*P.b/(2*Va)*r+P.C_Y_delta_a *delta_a+P.C_Y_delta_r *delta_r;
    f_a_z = c_z_alpha + c_z_q_alpha * P.c/(2*Va)*q + c_z_delta_e_alpha * delta_e;
    f_a = tmp * [f_a_x; f_a_y; f_a_z];
    
    %propulsion forces
    f_x_p = 1/2 * P.rho *P.S_prop * P.C_prop*( (P.k_motor *delta_t)^2 - Va^2);

    %aerodynamics moments
    tmp = 1/2 *P.rho * Va^2 * P.S_wing;
    m_l = P.C_ell_0 + P.C_ell_beta *beta + P.C_ell_p * P.b/(2*Va)*p + P.C_ell_r*P.b/(2*Va)*r + P.C_ell_delta_a * delta_a + P.C_ell_delta_r * delta_r;
    m_l = tmp *P.b*m_l;
    m_m = P.C_m_0 + P.C_m_alpha * alpha + P.C_m_q * P.c /(2*Va) * q + P.C_m_delta_e * delta_e;
    m_m = tmp*P.c *m_m;
    m_n = P.C_n_0 + P.C_n_beta * beta + P.C_n_p * P.b/(2* Va) *p + P.C_n_r * P.b/(2* Va) * r + P.C_n_delta_a * delta_a + P.C_n_delta_r * delta_r;
    m_n = tmp * P.b *m_n;

    % compute external forces and torques on aircraft
    Force(1) =  f_g(1) + f_a(1) + f_x_p;
    Force(2) =  f_g(2) + f_a(2);
    Force(3) =  f_g(3) + f_a(3);
    
    Torque(1) = m_l;
    Torque(2) = m_m;   
    Torque(3) = m_n;
    out = [Force'; Torque'; Va; alpha; beta; w_n; w_e; w_d];
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
