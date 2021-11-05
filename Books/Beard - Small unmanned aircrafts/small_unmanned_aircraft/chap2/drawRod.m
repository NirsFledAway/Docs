function handle = drawRod(y, theta, L, gap, height, handle, mode)
    X = [y, y+L*sin(theta)];
    Y = [gap+height, gap+height + L*cos(theta)];
    if isempty(handle),
       	handle = fill(X, Y, 'g', 'EraseMode', mode);
    else
        set(handle, 'XData', X, 'Ydata', Y);
    end