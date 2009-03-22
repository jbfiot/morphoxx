function [image,cage_filename,deformed_cage_filename] = switchset(set)
% [image,cage_filename,deformed_cage_filename] = switchset(set)
% 
% Get data corresponding to the input set name

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

switch set
    case 'Sonic'
        % Sonic set
        image = imread('Data/sonic-classic.jpg');
        cage_filename = 'Data/sonic_cage.txt';
        deformed_cage_filename = 'Data/sonic_def_cage.txt';

    case 'Checkerboard'
        % Checkerboard set
        image = imread('Data/100px-Checkerboard_pattern.svg.png');
        cage_filename = 'Data/checkerboard_cage.txt';
        deformed_cage_filename = 'Data/checkerboard_def_cage.txt';

    case 'L Checkerboard'
        % L checkerboard set
        image = imread('Data/L-checkerboard.png');
        cage_filename = 'Data/L-checkerboard_cage.txt';
        deformed_cage_filename = 'Data/L-checkerboard_def_cage.txt';

end

end
