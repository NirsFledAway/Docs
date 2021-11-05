function XYZ=spacecraftPoints
 % define points on the spacecraft in local NED coordinates
 XYZ = [...
    1       1       0;... % point 1
    1       -1      0;... % point 2
    -1      -1      0;... % point 3
    -1      1       0;... % point 4
    1       1       0;... % point 1
    1       1       -2;... % point 5
    1       -1      -2;... % point 6
    1       -1      0;... % point 2
    1       -1      -2;... % point 6
    -1      -1      -2;... % point 7
    -1      -1      0;... % point 3
    -1      -1      -2;... % point 7
    -1      1       -2;... % point 8
    -1       1       0;... % point 4
    -1      1       -2;... % point 8
    1       1       -2;... % point 5
    1       1       0;... % point 1
    1.5     1.5    0;... % point 9
    1.5     -1.5   0;... % point 10
    1       -1      0;... % point 2
    1.5     -1.5   0;... % point 10
    -1.5    -1.5   0;... % point 11
    -1      -1      0;... % point 3
    -1.5    -1.5   0;... % point 11
    -1.5    1.5    0;... % point 12
    -1      1       0;... % point 4
    -1.5    1.5    0;... % point 12
    1.5     1.5     0;... % point 9
]';