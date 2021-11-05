function handle = drawPendulum(u)
    display(u)
    % process inputs to function
    y		= u(1);
    theta	= u(2);
    t		= u(3);
    
    % drawing parammeters
    L = 1;
    gap = 0.01;
    width = 1.0;
    height = 0.1;
    
    %define persistent variables
    persistent base_handle
    persistent rod_handle
    
    % first time function is called, initialize plot
    % and peersistent vars
    if t==0,
        figure(1), clf
        track_width=3;
        plot([-track_width,track_width], [0,0], 'k');
        hold on
        base_handle = drawBase(y, width, height, gap, [], 'normal');
        rod_handle = drawRod(y, theta, L, gap, height, [], 'normal');
        axis([-track_width, track_width, -L, 2*track_width-L]);
        grid;
    % at every other time step, redraw base and rod
    else
        drawBase(y, width, height, gap, base_handle);
        drawRod(y, theta, L, gap, height, rod_handle);
    end
    