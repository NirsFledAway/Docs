function handle = drawSpacecraftBody2(u)
persistent spacecraft_handle;

pn = u(1);
pe = u(2);
pd = u(3);
phi = u(4);
theta = u(5);
psi = u(6);

[V, F, patchcolors] = spacecraftVFC;
% define points on spacecraft
V = rotate(V', phi, theta, psi)';
% rotate spacecraft
V = translate(V', pn, pe, pd)';
% translate spacecraft
R=[...
    0, 1, 0;...
    1, 0, 0;...
    0, 0, -1;...
];

V=V*R; % transform vertices from NED to XYZ
if isempty(spacecraft_handle),
    spacecraft_handle = patch('Vertices', V, 'Faces', F, ...
    'FaceVertexCData',patchcolors,...
    'FaceColor','flat',...
    'EraseMode', 'normal');
    grid on;
else
    set(spacecraft_handle,'Vertices',V,'Faces',F);
end