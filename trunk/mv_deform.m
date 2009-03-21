function deformed_pic = mv_deform(image,cage,deformed_cage)
% Deform a picture using the cage deformation and Mean Value Coordinates

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

[size_x,size_y,nb_channels] = size(image);
deformed_pic = ones(size(image));
in=0;
out=0;
for i=1:size_x
%     display(i);

    for j=1:size_y

        coord = mv_coord(deformed_cage,[i;j],0);
        before_def_point = cage*coord';
%         pause(0.5);
        before_def_x = before_def_point(1);
        before_def_y = before_def_point(2);
        
        [X,Y] = meshgrid(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1);

        if floor(before_def_x)>0 && floor(before_def_y)>0 && before_def_x<size_x && before_def_y<size_y
            deformed_pic(i,j,1) = interp2(X,Y,image(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1,1),before_def_x,before_def_y);
            deformed_pic(i,j,2) = interp2(X,Y,image(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1,2),before_def_x,before_def_y);
            deformed_pic(i,j,3) = interp2(X,Y,image(floor(before_def_x):floor(before_def_x)+1,floor(before_def_y):floor(before_def_y)+1,3),before_def_x,before_def_y);
            in = in+1;
        else
            out = out+1;
        end
        
    end
end
    
display(['IN:,',int2str(in)]);
display(['OUT:,',int2str(out)]);





end