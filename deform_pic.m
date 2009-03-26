function deformed_pic = deform_pic(pic,cage,deformed_cage,coord_type,interpolate)
% function deformed_pic = deform(pic,cage,deformed_cage,coord_type,interpolate)
% 
% Deform a picture using the cage deformation and Mean Value Coordinates
%
% Input
%   pic             : picture to deform
%   cage            : original cage
%   deformed_cage   : deformed cage
%   coord_type      : type of coordinates to use
%   interpolate     : boolean to tell if the program should interpolate the
%                       solution (basically set to 0 to speed up computation)
%
% Output
%   deformed_pic    : the picture after the deformation

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

[size_x,size_y,nb_channels] = size(pic);
deformed_pic = ones(size(pic));
in=0;
out=0;
coord=get_coord(deformed_cage,size_x,size_y,coord_type);


for i=1:size_x
    for j=1:size_y
        coord_p = coord(i,j,:);
        
        if (strcmp(coord_type,'MV') || strcmp(coord_type,'H'))
            % Mean Value and Harmonic are coordinates relative to the
            % positions of the vertices.
            before_def_point = cage*squeeze(coord_p);
        elseif strcmp(coord_type,'G')
            % Green coordinates also take into account the outward normals
            % of the edges (in 2D).
            outward_normals=get_outward_normals(cage);
           error('Not implemented yet'); 
        end

        before_def_x = before_def_point(1);
        before_def_y = before_def_point(2);
            
        if floor(before_def_x)>0 && floor(before_def_y)>0 && before_def_x<size_x && before_def_y<size_y
            if interpolate
                [X,Y] = meshgrid(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1);
                for k=1:nb_channels
                    deformed_pic(i,j,k) = interp2(X,Y,pic(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1,k),before_def_x,before_def_y);
                end
            else
                for k=1:nb_channels
                    deformed_pic(i,j,k) = pic(round(before_def_x),round(before_def_y),k);
                end
            end
            in = in+1;
        else
            out = out+1;
        end

    end
end

display(['IN: ',int2str(in)]);
display(['OUT: ',int2str(out)]);



deformed_pic=uint8(deformed_pic);

end