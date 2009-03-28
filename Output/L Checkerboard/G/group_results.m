% Script to group results for G.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc; clear;
suffix='.jpg';
prefix = 'Vertex ';

I=imread([prefix,'1',suffix]);
[sx,sy,sz]=size(I);
all_coords = zeros(2*sx,3*sy,sz,'uint8');

for i=1:12
    if i<=6
        prefix = 'Vertex ';
        I=imread([prefix,int2str(i),suffix]);
    else
        prefix = 'Edge ';
        I=imread([prefix,int2str(i-6),suffix]);
    end  
    if i<=3
        all_coords(1:sx,1+(i-1)*sy:i*sy,:)=I;
    elseif i<=6
        all_coords(sx+1:2*sx,1+(i-4)*sy:(i-3)*sy,:)=I;
    elseif i<=9
        all_coords(2*sx+1:3*sx,1+(i-7)*sy:(i-6)*sy,:)=I;
    else
        all_coords(3*sx+1:4*sx,1+(i-10)*sy:(i-9)*sy,:)=I;
    end
end

imwrite(all_coords,'G all coords.jpg');
figure;imshow(all_coords);

