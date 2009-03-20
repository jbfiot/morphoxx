function demogui(selector)
if nargin == 0
	selector = 0;
end

switch selector
case 0 % Initialize GUI application
	fig = figure('Position',[245 380 150 90],'CloseRequestFcn','demogui(4)','Resize','off');
	info.count = 1;
	uicontrol('Style','pushbutton','Position',[20 20 50 20],'String','Down','CallBack','demogui(1)')
	uicontrol('Style','pushbutton','Position',[80 20 50 20],'String','Up','CallBack','demogui(2)')
	info.editbox = uicontrol('Style','edit','Position',[45 50 60 20],'String',num2str(info.count),'CallBack','demogui(3)');
	set(fig,'UserData',info,'HandleVisibility','callback')
	
case 1 % Decrement counter
	fig = gcf;
	info = get(fig,'UserData');
	info.count = info.count - 1;
	set(info.editbox,'String',num2str(info.count))
	set(fig,'UserData',info)
	
case 2 % Increment counter
	fig = gcf;
	info = get(fig,'UserData');
	info.count = info.count + 1;
	set(info.editbox,'String',num2str(info.count))
	set(fig,'UserData',info)
	
case 3 % Enter value in edit box
	fig = gcf;
	info = get(fig,'UserData');
	newcount = sscanf(get(info.editbox,'String'),'%d');
	if ~isempty(newcount)
		info.count = newcount;
	end
	set(info.editbox,'String',num2str(info.count))
	set(fig,'UserData',info)

case 4 % Close requested
	answer = questdlg('Really close demogui?','','Yes','No','No');
	if strcmp(answer,'Yes')
		delete(gcf)
	end
	
end