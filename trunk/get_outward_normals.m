function normals = get_outward_normals(cage)
% function normals = get_outward_normals(cage)

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

normals = zeros(size(cage));

for k=1:size(cage,2)
   p1=cage(:,k);
   if k~=size(cage,2)
       p2=cage(:,k+1);
   else
       p2=cage(:,1);
   end
   % Getting a normal
   normals(:,k)=[p2(2)-p1(2);p1(1)-p2(1)]/norm(p2-p1);
   
   % For inpolygon: 
   %   y -> row number
   %   x -> column number
   
   xv = cage(2,:)';
   yv = cage(1,:)';

   % From the medium of the edge, we add twice the normal.
   test_point = (p1+p2)/2+2*normals(:,k);
   
   xv = [xv ; xv(1)]; yv = [yv ; yv(1)];
   in = inpolygon(test_point(2),test_point(1),xv,yv);
   
   % If we get in the polygon, we inverse the normal
   if in
       normals(:,k)=-normals(:,k);
   end 
end

end