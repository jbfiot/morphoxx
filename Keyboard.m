function Keyboard(src,evnt)
% Gestion des interruptions clavier

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

switch evnt.Key
    case 'e'
        CageGUI('end');
    case 'm'
        CageGUI('mesh');
    case 's'
        CageGUI('save');
    case 'c'
        CageGUI('clear');
    case 'q'
        CageGUI('exit');
    case 'r'
        fig = gcf; ud=get(fig,'UserData');
        delete(gcf);
        CageGUI('init',ud.image,ud.cage_filename,ud.deformed_cage_filename);
    case 'o'
        delete(gcf);
        CageGUI('select_set');
    case 'i'
        CageGUI('interior');
    case 'leftarrow'
        CageGUI('increase_cage_point_ind');
    case 'rightarrow'
        CageGUI('decrease_cage_point_ind');
        
    case 'd'
        CageGUI('deform');
    otherwise
        display(['Key pressed:', evnt.Key]);

end

end