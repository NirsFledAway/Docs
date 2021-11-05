addpath('../chap2')
addpath('../parameters/')
aerosonde_parameters
simulation_parameters
wind_parameters
addpath('../chap3')
addpath('../chap4')
addpath('../chap5')
compute_trim
compute_ss_model
compute_tf_model

save simulink_linear_model  A_lon B_lon A_lat B_lat T_phi_delta_a T_chi_phi T_theta_delta_e T_h_theta T_h_Va T_Va_delta_t T_Va_theta T_v_delta_r