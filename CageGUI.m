function CageGUI(selector,image,cage_filename,deformed_cage_filename)
% GUI

% File of the MorphoxX Project
% @author: JB Fiot (HellWoxX)

clc;
display('==============================================');
display('             MorphoxX project');
display('==============================================');

getd = @(p)path(path,p);
getd('distmesh/');

if nargin==0
    selector='select_set';
end


switch selector
    case 'select_set'
        set_list={'Sonic','Checkerboard'};
        [selection,ok]=listdlg('PromptString','Select a data set:', 'SelectionMode','single','ListString',set_list);
        if ~ok %default value if not chosen
            selection=1;
        end

        switch set_list{selection}
            case 'Sonic'
                % Sonic set
                image = imread('Data/sonic-classic.jpg');
                cage_filename = 'Data/sonic_cage.txt';
                deformed_cage_filename = 'Data/sonic_def_cage.txt';

            case 'Checkerboard'
                % Checkerboard set
                image = imread('Data/100px-Checkerboard_pattern.svg.png');
                cage_filename = 'Data/checkerboard_cage.txt';
                deformed_cage_filename = 'Data/checkerboard_def_cage.txt';
        end


        CageGUI('init',image,cage_filename,deformed_cage_filename)


    case 'init'
        set(0,'Units','pixels')
        scnsize = get(0,'ScreenSize');
        pos  = [452,7,	scnsize(3) - 455, scnsize(4)-90];
        fig = figure('Position',pos,'CloseRequestFcn','CageGUI(''exit'')','KeyPressFcn', @Keyboard);
        axes('Parent', fig);
        subplot(2,2,1);
        h1=imshow(image); hold on; title('Original cage');axis image;
        set(h1, 'ButtonDownFcn','CageGUI(''click'')');
        xlabel('R - Reload, C - Clear, S - Save, E - End, I - Interior, M - Mesh, O - Other set, Q - Quit');

        subplot(2,2,3);title('Deformed cage');
        h3=imshow(image); hold on; axis image; set(h3, 'ButtonDownFcn','CageGUI(''modif_def_cage_point'')');

        user_choice = 'Draw new cage';
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%        USER DATA          %%%%%%%%
        
        ud = struct('image', image,...
            'cage_filename', cage_filename, 'cage',[],'cage_finished',0,'cage_point_ind',1, ...
            'deformed_cage_filename', deformed_cage_filename, 'deformed_cage',[], ...
            'nodes',[],'triangle_ind',[]);

        set(fig,'UserData',ud);
        
        %%%%%       END USER DATA       %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % We propose the user to use the saved cage if it exists
        if exist(cage_filename,'file')==2
            user_choice = questdlg(['Cage file ',cage_filename,'  was found. What do u wanna do?'],'Cage file found.','Use saved cage','Draw new cage','Use saved cage');
        end
        
        % We propose the user to use the saved deformed cage if he has
        % chosen to use the 1st cage, if the def cage file exists, and if
        % the corresponding file has as many points as the previous one.
        
        if strcmp(user_choice,'Use saved cage')==1
            ud.cage = load(cage_filename);
            if exist(deformed_cage_filename,'file')==2
                deformed_cage=load(deformed_cage_filename);
                if size(ud.cage)==size(deformed_cage);
                    user_choice = questdlg(['Cage file ',deformed_cage_filename,'  was found. What do u wanna do?'],'Cage file found.','Use saved cage','Initialize with original cage','Use saved cage');
                    switch user_choice
                        case 'Use saved cage'
                            ud.deformed_cage = deformed_cage;
                        case 'Initialize with original cage'
                            ud.deformed_cage = ud.cage;
                    end
                else
                    delete(deformed_cage_filename);
                    display(['Deformed cage ',deformed_cage_filename,' has been deleted cuz corrupted.']);
                end
                clear deformed_cage;
            end
            set(fig,'UserData',ud);
            CageGUI('end');
        end

        


    case 'click'
        fig = gcf; ud=get(fig,'UserData');
        subplot(2,2,1);
        ah1 = gca; pt=get(ah1,'CurrentPoint');
        if ~ud.cage_finished
            ud.cage=[ud.cage,[pt(1,2);pt(1,1)]];
            if size(ud.cage,2)>1
                line(ud.cage(2,end-1:end),ud.cage(1,end-1:end));
            end
            h = plot(ud.cage(2,:),ud.cage(1,:), '.c');set(h, 'MarkerSize', 20 );
            set(fig,'UserData',ud);
        else
            mv_coord(ud.cage,[pt(1,1);pt(1,2)],1);
        end

    case 'end' % End
        fig = gcf; ud=get(fig,'UserData');
        subplot(2,2,1); draw_cage(ud.cage);

        ud.cage_finished=1;
        if isequal(size(ud.deformed_cage),[0,0])
            % If the deformed cage not created yet (with a saved cage
            % file), we initialize the deformed cage as the original cage.
            display('Deformed cage initialized to original cage.');
            ud.deformed_cage = ud.cage;
        end

        subplot(2,2,3);draw_cage(ud.deformed_cage,ud.image,ud.cage_point_ind);
        set(fig,'UserData',ud);

    case 'increase_cage_point_ind'
        fig = gcf; ud=get(fig,'UserData');
        if ud.cage_point_ind ~=size(ud.deformed_cage,2)
            ud.cage_point_ind = ud.cage_point_ind+1;
        else
            ud.cage_point_ind = 1;
        end
        subplot(2,2,3);draw_cage(ud.deformed_cage,ud.image,ud.cage_point_ind);
        set(fig,'UserData',ud);

    case 'decrease_cage_point_ind'
        fig = gcf; ud=get(fig,'UserData');
        if ud.cage_point_ind~=1
            ud.cage_point_ind = ud.cage_point_ind-1;
        else
            ud.cage_point_ind = size(ud.deformed_cage,2);
        end
        subplot(2,2,3);draw_cage(ud.deformed_cage,ud.image,ud.cage_point_ind);
        set(fig,'UserData',ud);


    case 'modif_def_cage_point'
        fig = gcf; ud=get(fig,'UserData');
        if ud.cage_finished        
            ah1 = gca; pt=get(ah1,'CurrentPoint');
            % Update point
            ud.deformed_cage(:,ud.cage_point_ind)=[pt(1,2);pt(1,1)]; 
            % Redraw cage
            subplot(2,2,3);draw_cage(ud.deformed_cage,ud.image,ud.cage_point_ind);
            % Save deformed cage
            set(fig,'UserData',ud);
        else
            display('Finish 1st cage before! :p');
        end
        
    case 'deform'
        fig = gcf; ud=get(fig,'UserData');
        subplot(2,2,1);
        if ud.cage_finished
            display('Computing deformation... (Long process, please be patient)');
            deformed_pic = deform(ud.image,ud.cage,ud.deformed_cage,'MV');
            subplot(2,2,3);draw_cage(ud.deformed_cage,deformed_pic,ud.cage_point_ind);
            display('Done.');
        else
            display('Finish the cage before!');
        end
        
        
        
        
    case 'save'
        fig = gcf; ud=get(fig,'UserData');
        points2save=ud.cage; % We cannot save directly ud.cage
        save(ud.cage_filename,'points2save','-ascii'); 
        points2save=ud.deformed_cage;
        save(ud.deformed_cage_filename,'points2save','-ascii');        
        display('Cages successfully saved');

    case 'exit' % Exit
        display('hope u ''njoyed!');
        delete(gcf);

    case 'interior'
        fig = gcf; ud=get(fig,'UserData');
        xv = ud.cage(2,:)';
        yv = ud.cage(1,:)';
        step=10;
        [x,y] = meshgrid(1:step:size(ud.image,2),1:step:size(ud.image,1));
        xv = [xv ; xv(1)]; yv = [yv ; yv(1)];
        in = inpolygon(x,y,xv,yv);
        plot(x(in),y(in),'.r',x(~in),y(~in),'.b');


    case 'mesh' % Mesh
        display('Computing mesh...');
        fig = gcf; ud=get(fig,'UserData');
        if ud.cage_finished
            subplot(2,2,2);

            %DISTMESH2D 2-D Mesh Generator using Distance Functions.
            %   [P,T]=DISTMESH2D(FD,FH,H0,BBOX,PFIX,FPARAMS)
            %
            %      P:         Node positions (Nx2)
            %      T:         Triangle indices (NTx3)
            %      FD:        Distance function d(x,y)
            %      FH:        Scaled edge length function h(x,y)
            %      H0:        Initial edge length
            %      BBOX:      Bounding box [xmin,ymin; xmax,ymax]
            %      PFIX:      Fixed node positions (NFIXx2)
            %      FPARAMS:   Additional parameters passed to FD and FH


            %         figure;
            %         set(gcf,'rend','z');
            box=[-1,-1;1,1];

            %         n=6;
            %         phi=(0:n)'/n*2*pi;
            %         fix=[cos(phi),sin(phi)]
            %         fd=inline('dpoly(p,fix)','p','fix');
            %         [p,t]=distmesh2d(fd,@huniform,0.1,box,fix,fix);
            %         fd=inline('ddiff(dpoly(p,fix),dpoly(p,.5*fix*[cos(pi/6),-sin(pi/6);sin(pi/6),cos(pi/6)]))','p','fix');
            %         [p,t]=distmesh2d(fd,@huniform,0.1,box,[fix;.5*fix*[cos(pi/6),-sin(pi/6);sin(pi/6),cos(pi/6)]],fix);


            fd=inline('dpoly(p,fix)','p','fix');
            fh=@huniform;
            fix = [ud.cage(2,:)',size(ud.image,1)-ud.cage(1,:)';ud.cage(2,1)',size(ud.image,1)-ud.cage(1,1)']; % last=1st like the example...
            fix = fix/max(fix(:)); % Normalization, otherwise it does not work... :/ TO INVESTIGATE...

            [ud.nodes,ud.triangle_ind]=distmesh2d(fd,fh,0.1,box,fix,fix);

            display(['Done: ',int2str(length(ud.nodes)),' nodes, ',int2str(length(ud.triangle_ind)),' triangles.'])
            set(fig,'UserData',ud);

        else
            display('Finish your cage!');
        end



    case 'clear' % clear
        user_choice = questdlg('Are you sure?','Clear cage??','Yes','No','No');
        if strcmp(user_choice,'Yes')==1
            fig = gcf; ud=get(fig,'UserData');
            if exist(ud.cage_filename,'file')==2
                delete(ud.cage_filename);
            end
            CageGUI('init',ud.image,ud.cage_filename,ud.deformed_cage_filename);
        end

end
end


% function post(p,t,fh,varargin)
% q=simpqual(p,t);
% u=uniformity(p,t,fh,varargin{:});
% disp(sprintf(' - Min quality %.2f',min(q)))
% disp(sprintf(' - Uniformity %.1f%%',100*u))
% end