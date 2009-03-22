function coord = mv_coord(cage,p,coord_type,verbose)
% function coord = mv_coord(cage,p,coord_type,verbose)
% 
% Compute Mean Value Coordinates of a point p within the input cage
%
% Input
%   cage                : dim 2*nb_points
%   p                   : dim 2*1
%   coord_type          : {'MV','H','G'} for "Mean Value", "Harmonic" and "Green" coordinates
%   verbose (optional)  : boolean
%
% Ouptut
%   coord   : Mean Value coordinates


% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)


switch coord_type
    case 'MV'
        % =========================================================================
        %                       Mean Value Coordinates
        % =========================================================================
        %
        % Ref. [Hormann, Floater] Mean Value Coordintates for Arbitrary Planar Polygons
        %
        % Let {Vi} be the vertices in the cage
        % Let Ri(p) = ||p-Vi||
        % Let Ai be the signed area of the triangle [p, Vi, Vi+1] at the vertex p
        % Let Bi be the signed area of the triangle [p, Vi-1, Vi+1] at the vertex p

        Vrel = cage-repmat(p,[1,size(cage,2)]);
        coord = zeros(1,size(cage,2));
        r=zeros(size(coord));
        A=zeros(size(coord));
        B=zeros(size(coord));

        % Compute distances to vertices
        for i=1:length(r)
            r(i)=norm(Vrel(:,i));
        end

        % Compute signed triangle areas
        for i=1:length(r)-1
            tmp = cross([Vrel(:,i);0],[Vrel(:,i+1);0]);
            A(i)=tmp(3)/2;
        end
        tmp = cross([Vrel(:,length(r));0],[Vrel(:,1);0]);
        A(length(r))=tmp(3)/2;

        for i=2:length(r)-1
            tmp = cross([Vrel(:,i-1);0],[Vrel(:,i+1);0]);
            B(i)=tmp(3)/2;
        end
        tmp = cross([Vrel(:,length(r));0],[Vrel(:,2);0]);
        B(1)=tmp(3)/2;
        tmp = cross([Vrel(:,length(r)-1);0],[Vrel(:,1);0]);
        B(length(r))=tmp(3)/2;

        clear tmp;

        % Weight functions
        % weight = [r(1)/(A(end)*A(1)),r(2:end)./(A(1:end-1).*A(2:end))];

        % Compute MV Coords
        coord = [(r(end)*A(1)-r(1)*B(1)+r(2)*A(end))/(A(end)*A(1)) ,... % elem #1
            (r(1:end-2).*A(2:end-1)-r(2:end-1).*B(2:end-1)+r(3:end).*A(1:end-2))./(A(1:end-2).*A(2:end-1)),... % elem #2 to #end-1
            (r(end-1)*A(end)-r(end)*B(end)+r(1)*A(end-1))/(A(end-1)*A(end))]; % last elem

        % Normalization
        coord = coord/sum(coord);
        if nargin>3
            if verbose
                display(coord);
            end
        end

    case 'H'
        % =========================================================================
        %                        Harmonic Coordinates
        % =========================================================================
        %
        % Ref. DEROSE, T., AND MEYER, M. 2006. Harmonic coordinates.
        %       Pixar Technical Memo 06-02, Pixar Animation Studios, January.
        %
        
    case 'G'
        
    otherwise
        error('Unknown coord_type');
end














