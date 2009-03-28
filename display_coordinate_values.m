% Script to display the coordinate values of the vertices
% Results are saved in 'Output'
% 
% Disclaimer
% ==========
% This display is done on the original cages because they have more interesting
% shapes than the deformed cages in our sets. They have actually no
% interest at all in our final goal (deforming the pictures), this script is only
% here as a visual illustration of the different kinds of coordinates.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;

display('Computing... ');

set = 'L Checkerboard';
coord_type = 'G';
[image,cage_filename] = switchset(set);
cage = load(cage_filename);

create_output_dir;

% Getting coords
coord_values = get_coord(cage,size(image,1),size(image,2),coord_type);

vertex_nb = size(cage,2);

% Display and save
figure;
for vertex_ind = 1:vertex_nb;
    clf; draw_cage(cage,coord_values(:,:,vertex_ind)); colormap('hot'); colorbar; 
    name = ['Output/',set,'/', coord_type, '/Vertex ',int2str(vertex_ind),'.jpg'];
    waitforbuttonpress;
    results=frame2im(getframe(gcf));imwrite(results,name);
end


if size(coord_values,3)>vertex_nb % This is the case for Greeen Coordinates
    for edge_ind = vertex_nb+1:2*vertex_nb;
        clf; draw_cage(cage,coord_values(:,:,edge_ind)); colormap('hot'); colorbar;
        name = ['Output/',set,'/', coord_type, '/Edge ',int2str(edge_ind-vertex_nb),'.jpg'];
        waitforbuttonpress;
        results=frame2im(getframe(gcf));imwrite(results,name);
    end
end

waitforbuttonpress;
close(gcf);

display('Done');
