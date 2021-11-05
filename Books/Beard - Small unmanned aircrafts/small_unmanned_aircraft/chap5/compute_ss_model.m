% x_trim is the trimmed state,
% u_trim is the trimmed input
  
  
[A,B,C,D]=linmod('mavsim_trim',x_trim,u_trim);


E1 = [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0];
    
E2 = [0, 1, 0, 0;
        0, 0, 1, 0];

A_lat = E1 * A *E1'
B_lat = E1 * B *E2'

%A_lon = 
%B_lon = 
  


