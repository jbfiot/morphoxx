% Script to display the coordinate values of the vertices
% Results are saved in 'Output'

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;

display('Computing... ');

set = 'L Checkerboard';
coord_type = 'H';
[image,cage_filename] = switchset(set);
cage = load(cage_filename);

if ~exist('Output','dir')
    mkdir('Output');
end
if ~exist(['Output/',set],'dir')
    mkdir(['Output/',set]);
end

if ~exist(['Output/',set,'/',coord_type],'dir')
    mkdir(['Output/',set,'/',coord_type]);
end

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
