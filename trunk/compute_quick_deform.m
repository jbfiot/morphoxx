% Script to directly deform the pic using the saved cages.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;
set = 'L2 Checkerboard';
interpolate = 0;
coord_type = 'G';
save = 1;

[image,cage_filename,deformed_cage_filename] = switchset(set);

cage = load(cage_filename);
deformed_cage=load(deformed_cage_filename);

display('Computing deformation... (Long process, please be patient)');
deformed_pic = deform_pic(image,cage,deformed_cage,coord_type,interpolate);


figure;
subplot(1,2,1);
draw_cage(cage,image);
subplot(1,2,2);
draw_cage(deformed_cage,deformed_pic);

if save
    waitforbuttonpress;
    create_output_dir;
    name = ['Output/',set,'/',coord_type,' Deform - Interp',int2str(interpolate),'.jpg'];
    results=frame2im(getframe(gcf));imwrite(results,name);
end

display('Done');

close(gcf);