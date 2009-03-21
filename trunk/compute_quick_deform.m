% Script to directly deform the pic using the saved cages.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;
set = 'L Checkerboard';
interpolate = 0;
coord_type = 'MV';

[image,cage_filename,deformed_cage_filename] = switchset(set);

ud = struct('image', image,...
    'cage_filename', cage_filename, 'cage',[],'cage_finished',0,'cage_point_ind',1, ...
    'deformed_cage_filename', deformed_cage_filename, 'deformed_cage',[], ...
    'nodes',[],'triangle_ind',[]);

ud.cage = load(cage_filename);
ud.deformed_cage=load(deformed_cage_filename);


figure;
subplot(1,2,1);
draw_cage(ud.cage,image);
subplot(1,2,2);
display('Computing deformation... (Long process, please be patient)');
deformed_pic = deform(ud.image,ud.cage,ud.deformed_cage,coord_type,interpolate);
draw_cage(ud.deformed_cage,deformed_pic);
display('Done.');


