% Script to group results for MV.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear;
prefix = 'Vertex ';
suffix='.jpg';


I=imread([prefix,'1',suffix]);
[sx,sy,sz]=size(I);
all_coords = zeros(2*sx,3*sy,sz,'uint8');

for i=1:6
    I=imread([prefix,int2str(i),suffix]);
    if i<4
        all_coords(1:sx,1+(i-1)*sy:i*sy,:)=I;
    else
        all_coords(sx+1:2*sx,1+(i-4)*sy:(i-3)*sy,:)=I;
    end
end

imwrite(all_coords,'MV all coords.jpg');
figure;imshow(all_coords);