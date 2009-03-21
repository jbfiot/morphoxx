% Script to display the coordinate values of the vertices
% Results are saved in 'Output'

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear; close all;

display('Computing... Please be patient and let Matlab keep the focus!');
set = 'Checkerboard';
if ~exist('Output','dir')
    mkdir('Output');
end
if ~exist(['Output/',set],'dir')
    mkdir(['Output/',set]);
end
interpolate = 1;
coord_type = 'MV';
[image,cage_filename] = switchset(set);
cage = load(cage_filename);

coord_values = zeros(size(image,1),size(image,2));

figure;

for vertex_nb = 1:size(cage,2);
    for i=1:size(image,1)
        for j=1:size(image,2)
            switch coord_type
                case 'MV'
                    tmp = mv_coord(cage,[i;j]);
                    coord_values(i,j) = tmp(vertex_nb);
            end
        end
    end

    clf; draw_cage(cage,coord_values,vertex_nb); colormap('hot'); colorbar; 
    name = ['Output/',set,'/', coord_type, ' coord for vertex ',int2str(vertex_nb),'.jpg'];
    results=frame2im(getframe(gcf));imwrite(results,name);
end

display('Done');
