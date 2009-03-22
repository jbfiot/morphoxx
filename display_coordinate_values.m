% Script to display the coordinate values of the vertices
% Results are saved in 'Output'

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;

display('Computing... Please be patient and let Matlab keep the focus!');

set = 'Sonic';
coord_type = 'MV';
[image,cage_filename] = switchset(set);
cage = load(cage_filename);

if ~exist('Output','dir')
    mkdir('Output');
end
if ~exist(['Output/',set],'dir')
    mkdir(['Output/',set]);
end


% Getting coords
coord_values = get_coord(cage,size(image,1),size(image,2),coord_type);

vertex_nb = size(cage,2);

% Display and save
figure;
for vertex_ind = 1:vertex_nb;
    clf; draw_cage(cage,coord_values(:,:,vertex_ind)); colormap('hot'); colorbar; 
    name = ['Output/',set,'/', coord_type, ' coord for vertex ',int2str(vertex_ind),'.jpg'];
    results=frame2im(getframe(gcf));imwrite(results,name);
    waitforbuttonpress;
end

display('Done');
