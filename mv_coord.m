function coord = mv_coord(cage,p,verbose)
% Compute Mean Value Coordinates of a point p within the input cage

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

V = cage-repmat(p,[1,size(cage,2)]);
coord = zeros(1,size(cage,2));
r=zeros(size(coord));
A=zeros(size(coord));
B=zeros(size(coord));
for i=1:length(r)
    r(i)=norm(V(:,i));
end
for i=1:length(r)-1
    A(i)=norm(cross([V(:,i);0],[V(:,i+1);0]));
end
A(length(r))=norm(cross([V(:,length(r));0],[V(:,1);0]));

for i=2:length(r)-1
    B(i)=norm(cross([V(:,i-1);0],[V(:,i+1);0]));
end
B(1)=norm(cross([V(:,length(r));0],[V(:,2);0]));
B(length(r))=norm(cross([V(:,length(r)-1);0],[V(:,1);0]));

coord = [(r(end)*A(1)-r(1)*B(1)+r(2)*A(end))/(A(end)*A(1)) ,...
    (r(1:end-2).*A(2:end-1)-r(2:end-1).*B(2:end-1)-r(3:end).*A(1:end-2))./(A(1:end-2).*A(2:end-1)),...
    (r(end-1)*A(end)-r(end)*B(end)+r(1)*A(end-1))/(A(end)*A(end-1))];

coord = coord/sum(coord);

if verbose
    display(coord);
end
end