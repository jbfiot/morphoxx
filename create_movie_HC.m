% This script creates a movie to see the computations of the HC at different iteration #.
% The code is for the L-Checkerboard, because the shape has a low number of vertices.
%
% Disclaimer
% ==========
% This movie is done on the original cage because it has a more interesting
% shape than the deformed cage for the L-Checkerboard set. It has actually no
% interest at all in our final goal (deforming the pictures), this script is only
% here to get a visual illustration.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)


clc; clear; close all;

display('Creating movie... ');

set = 'L Checkerboard';
[image,cage_filename] = switchset(set);
cage = load(cage_filename);

create_output_dir;
size_x=size(image,1);size_y=size(image,2);nb_vertices=size(cage,2);

coord = zeros(size_x,size_y,nb_vertices);
pic_mask = poly2mask(cage(2,:),cage(1,:),size_x,size_y);
pic_mask = 255*uint8(pic_mask); % Exterior: 0, Interior: 255

for i=1:size_x
    for j=1:size_y
        for k=1:nb_vertices
            p1=cage(:,k);
            if k~=nb_vertices
                ind2=k+1;
            else
                ind2=1;
            end
            p2=cage(:,ind2);
            if (norm(cross([p2-p1;0],[[i;j]-p1;0]))/norm(p1-p2)<=.5 && max(norm(p1-[i;j]),norm(p2-[i;j]))<norm(p1-p2))
                pic_mask(i,j)=128;
                coord(i,j,k) = norm([i;j]-p2)/norm(p1-p2); % Value is 1 in vertex k, 0 in vertex k+1
                coord(i,j,ind2)= norm([i;j]-p1)/norm(p1-p2); % Inverse values
            end
        end
    end
end


interior_ind=find(pic_mask==255);
int_nb=length(interior_ind);
ind2update = zeros(int_nb*nb_vertices,1);

for i=1:nb_vertices
    ind2update((i-1)*int_nb+1:i*int_nb) = interior_ind+(i-1)*size_x*size_y;
end



average_modif=1;average_modif_threshold = 1e-9;
init_coord=coord;
new_coord=coord;
niter_max = 200;


figure;

for vertex_nb=1:nb_vertices
    coord=init_coord;
    
    % One particular vertex
    % =====================
    filename = ['Output/L Checkerboard/H/Vertex ',int2str(vertex_nb),' - ',int2str(niter_max),' iterations.avi'];
    if exist(filename,'file')==2
        delete(filename);
    end
    mov = avifile(filename);

    for niter=1:niter_max
        draw_cage(cage,coord(:,:,vertex_nb)); colormap('hot'); colorbar; title(['Vertex ',int2str(vertex_nb),' Iter #',int2str(niter)]);

        F = getframe; mov = addframe(mov,F);

        new_coord(ind2update)=(coord(ind2update-1)+coord(ind2update+1)+coord(ind2update-size_x)+coord(ind2update+size_x))/4;
        coord = new_coord;
    end

    mov=close(mov);
end

close(gcf);



% All vertices
% ============

coord=init_coord;
filename = ['Output/L Checkerboard/H/All vertices - ',int2str(niter_max),' iterations.avi'];
if exist(filename,'file')==2
    delete(filename);
end
mov = avifile(filename);

figure('Position',[50 50 1600 1000]);

for niter=1:niter_max
    for vertex_nb=1:nb_vertices
        subplot(2,3,vertex_nb);
        draw_cage(cage,coord(:,:,vertex_nb)); colormap('hot'); colorbar; title(['Vertex ',int2str(vertex_nb),' Iter #',int2str(niter)]);
    end

    F = getframe(gcf);mov = addframe(mov,F);

    new_coord(ind2update)=(coord(ind2update-1)+coord(ind2update+1)+coord(ind2update-size_x)+coord(ind2update+size_x))/4;
    coord = new_coord;
end

mov=close(mov);
close(gcf);

display('Done');






























