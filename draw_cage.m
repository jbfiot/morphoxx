function draw_cage(cage,image,active_point)
% function draw_cage(cage,image,active_point)
%
% This function draws the input cage onto the input image.
% If specified, the active point is displayed in red.
% Other points are displayed in cyan.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)


[ST,I] = dbstack(1);

if strcmp(ST(1).name,'CageGUI')
    h3=imshow(image); hold on; axis off;
    if nargin==3
        set(h3, 'ButtonDownFcn','CageGUI(''modif_def_cage_point'')');
    end
elseif strcmp(ST(1).name,'display_coordinate_values')
    h3=imagesc(image); hold on; axis off;
end


h = plot(cage(2,:),cage(1,:), '.c');set(h, 'MarkerSize', 20 );
for i=1:size(cage,2)-1
    line(cage(2,i:i+1),cage(1,i:i+1));
end

if size(cage,2)>1
    line(cage(2,[1,end]),cage(1,[1,end]));
end

if nargin > 2
    h=plot(cage(2,active_point),cage(1,active_point), '.r');set(h, 'MarkerSize', 20 );
end
        
end