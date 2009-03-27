% Script to get progressive deformations of the pic using the saved cages.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;
set = 'Light Sonic';
interpolate = 0;
coord_type = 'MV';
save = 1;

[image,cage_filename,deformed_cage_filename] = switchset(set);

cage = load(cage_filename);
deformed_cage=load(deformed_cage_filename);
display('Computing deformation... (Long process, please be patient)');


figure;
subplot(2,3,1);
draw_cage(cage,image);title('0%');


for i=2:6
    intermediate_cage = (1-(i-1)*.2)*cage+((i-1)*.2)*deformed_cage;
    subplot(2,3,i);
    deformed_pic = deform_pic(image,cage,intermediate_cage,coord_type,interpolate);
    draw_cage(intermediate_cage,deformed_pic);title([int2str((i-1)*20),'%']);
end




if save
    waitforbuttonpress;
    create_output_dir;
    name = ['Output/',set,'/',coord_type,' Progressive - Interp',int2str(interpolate),'.jpg'];
    results=frame2im(getframe(gcf));imwrite(results,name);
end

close(gcf);

display('Done');