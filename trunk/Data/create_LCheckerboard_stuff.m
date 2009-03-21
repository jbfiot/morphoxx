% Script to generate the L checkerboard from the simple checkerboard, and some cages for it.

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)


I=imread('100px-Checkerboard_pattern.svg.png');

I=I(1:3:end,1:3:end,:);

I2=[ones(16,100,3);...
    ones(34,16,3),I,ones(34,50,3);...
    ones(34,16,3),I(:,8:end,:),I(:,8:14,:),I,ones(34,16,3);...
    ones(16,100,3)];

imwrite(I2, 'L-checkerboard.jpg');

cage = [16.5,84.5,84.5,50.5,50.5,16.5;
        16.5,16.5,84.5,84.5,50.5,50.5];
    
save('L-checkerboard_cage.txt','cage','-ascii'); 

deformed_cage = [16.5,50.5,50.5,50.5,16.5,16.5;
                16.5,16.5,50.5,84.5,84.5,50.5];
save('L-checkerboard_def_cage.txt','deformed_cage','-ascii'); 




