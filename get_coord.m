function coord = get_coord(cage,size_x,size_y,coord_type)
% function coord = get_coord(cage,p,coord_type,verbose)
% 
% Compute Coordinates of a point p within the input cage
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

nb_vertices = size(cage,2);

switch coord_type
    case 'MV'
        coord = zeros(size_x,size_y,nb_vertices);
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
        
        for p1=1:size_x
            for p2=1:size_y
                p=[p1;p2];

                Vrel = cage-repmat(p,[1,nb_vertices]);
                r=zeros(1,nb_vertices);
                A=zeros(1,nb_vertices);
                B=zeros(1,nb_vertices);

                % Compute distances to vertices
                for i=1:nb_vertices
                    r(i)=norm(Vrel(:,i));
                end

                % Compute signed triangle areas
                for i=1:nb_vertices-1
                    tmp = cross([Vrel(:,i);0],[Vrel(:,i+1);0]);
                    A(i)=tmp(3)/2;
                end
                tmp = cross([Vrel(:,length(r));0],[Vrel(:,1);0]);
                A(length(r))=tmp(3)/2;

                for i=2:nb_vertices-1
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
                coord(p1,p2,:) = [(r(end)*A(1)-r(1)*B(1)+r(2)*A(end))/(A(end)*A(1)) ,... % elem #1
                    (r(1:end-2).*A(2:end-1)-r(2:end-1).*B(2:end-1)+r(3:end).*A(1:end-2))./(A(1:end-2).*A(2:end-1)),... % elem #2 to #end-1
                    (r(end-1)*A(end)-r(end)*B(end)+r(1)*A(end-1))/(A(end-1)*A(end))]; % last elem

                % Normalization
                coord(p1,p2,:) = coord(p1,p2,:)/sum(coord(p1,p2,:));
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
        

        % Creating the mask
        display('Creation of the mask and initialization of the coordinates...');
        coord = zeros(size_x,size_y,nb_vertices);
        pic_mask = poly2mask(cage(2,:),cage(1,:),size_x,size_y);
        pic_mask = 255*uint8(pic_mask); % Exterior: 0, Interior: 255

        % Adding the 'BOUNDARY' labels, and initializing the coords for the
        % boundary pixels
        for i=1:size_x
            for j=1:size_y
                for k=1:nb_vertices-1
                    p1=cage(:,k);
                    if k~=nb_vertices
                        p2=cage(:,k+1);
                    else
                        p2=cage(:,1);
                    end
                    if (norm(cross([p2-p1;0],[[i;j]-p1;0]))/norm(p1-p2)<.5 && max(norm(p1-[i;j]),norm(p2-[i;j]))<norm(p1-p2))
                        % If the distance from the pixel to the edge is
                        % less than 0.5 pixel, and the max distance to 
                        % the vertices is less than the length of the 
                        % edge,  we consider this pixel on the boundary
                        % (corresponding value for the mask: 128)
                        pic_mask(i,j)=128;
                        coord(i,j,k) = norm([i;j]-p2)/norm(p1-p2); % Value is 1 in vertex k, 0 in vertex k+1
                        coord(i,j,k+1)= norm([i;j]-p1)/norm(p1-p2); % Inverse values
                    end
                end
            end
        end
        
        % Display pic_mask (useful for debug)
%         f=gcf; figure;imshow(pic_mask);title('pic mask'); figure(f);
        display('Done');
        

        % Laplacian Smoothing
        display('Laplacian smoothing...');
        niter_max = 2;
        [X_ind,Y_ind]=find(pic_mask==255);
%         nb_int_points = length(X_ind);        
        average_modif=1;
        new_coord=zeros(size_x,size_y,nb_vertices);
        niter=1;

        while (average_modif<1e-3 || niter<niter_max)
            niter=niter+1;

            new_coord(X_ind,Y_ind,:)=(coord(X_ind-1,Y_ind,:)+coord(X_ind+1,Y_ind,:)+coord(X_ind,Y_ind-1,:)+coord(X_ind,Y_ind+1,:))/4;

            average_modif = mean(new_coord(X_ind,Y_ind,:)-coord(X_ind,Y_ind,:));
               
            coord = new_coord;
        end
        
        if (niter==niter_max)
            display('Maximum number of iterations reached in the computation of Harmonic Coordinates');
        end
        
        % Normalisation
        % -> à rajouter qd le pb de RAM sera rêglé...
        
        display('Done');
             
        
    case 'G'
        % =========================================================================
        %                         Green Coordinates
        % =========================================================================
        %
        % Ref. Y. Lipman, D. Levin, D. Cohen-Or. Green Coordinates.
        
        coord = zeros(size_x,size_y,2*nb_vertices);
        for i=1:size_x
            for j=1:size_y
                eta=[i;j];
                for k=1:nb_vertices-1
                    v1=cage(:,k);
                    if k~=nb_vertices
                        v2=cage(:,k+1);
                    else
                        v2=cage(:,1);
                    end
                    a = v2-v1; b=v1-eta;
                    Q = norm(a);S=norm(b);R=2*dot(a,b);
                    BA = dot(b,Q*..); SRT = sqrt(4*S*Q-R^2);
                    L0=log(S);
                    L1=log(S+Q+R);
                    A0=atan(R/(S*R*T))/(S*R*T);
                    A1=atan((2*Q+R)/(S*R*T))/(S*R*T);
                    A10=A1-A0;L10=L1-L0;
                    coord(i,j,..) = -Q/(4*pi)*((4*S-R^2)*A10+R/(2*Q)*L10+L1-2);
                    coord(i,j,..) = coord(i,j,..) - BA/(2*pi)*(L10/(2*Q)-A10*R/Q);
                    coord(i,j,..) = coord(i,j,..) + BA/(2*pi)*(L10/(2*Q)-A10*(2+R/Q));

                end
            end
        end
        
        error('Not implemented yet');
        
    otherwise
        error('Unknown coord_type');
end














