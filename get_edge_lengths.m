function edge_lengths = get_edge_lengths(cage)
% function edge_lengths = get_edge_lengths(cage)
% 
% This function returns the lengths of the edges of a cage

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

    orig_points = cage;
    final_points = [cage(:,2:end),cage(:,1)];
    edge_lengths = sqrt(sum((final_points-orig_points).^2));
end