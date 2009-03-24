% Script to group results for MV.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear;
prefix = 'Vertex ';
suffix='.jpg';


I=imread([prefix,'1',suffix]);
[sx,sy,sz]=size(I);
all_coords = zeros(2*sx,5*sy,sz,'uint8');

for i=1:10
    I=imread([prefix,int2str(i),suffix]);
    if i<6
        all_coords(1:sx,1+(i-1)*sy:i*sy,:)=double(I);
    else
        all_coords(sx+1:2*sx,1+(i-6)*sy:(i-5)*sy,:)=double(I);
    end
end

imwrite(all_coords,'MV all coords.jpg');
figure;imshow(all_coords);