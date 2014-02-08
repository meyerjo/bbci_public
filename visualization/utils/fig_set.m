function fig_set(varargin)
%FIG_SET

props= {'Fn'              1            '!INT'
        'ToolsOff'        1            '!BOOL'
        'GridSize'        [2 2]        '!DOUBLE[2]'
        'Resize'          [1 1]        '!DOUBLE[2]'
        'ShiftUpwards'    1            '!BOOL'
        'Name'            ''           'CHAR'
        'Clf'             0            '!BOOL'
        'Props'           {}           'PROPLIST'
        'DesktopBorder'   [0 30 0 0]   '!DOUBLE[4]'
        'WindowBorder'    [5 20]       '!DOUBLE[2]'
       };

if nargin>0 && isnumeric(varargin{1}),
  opt= opt_proplistToStruct(varargin{2:end});
  opt.Fn= varargin{1};
else
  opt= opt_proplistToStruct(varargin{:});
end
[opt, isdefault]= opt_setDefaults(opt, props);

pos_screen= get(0, 'ScreenSize');
actualsize(1)= pos_screen(3) - opt.GridSize(2)*2*opt.WindowBorder(1);
actualsize(2)= pos_screen(4) - opt.GridSize(1)*sum(opt.WindowBorder);
actualsize= actualsize - sum(opt.DesktopBorder([1 2; 3 4]));

fig_size= floor(actualsize./fliplr(opt.GridSize));
iv= mod(opt.GridSize(1) - 1 - floor((opt.Fn-1)/opt.GridSize(2)), opt.GridSize(1));
ih= mod(opt.Fn-1, opt.GridSize(2));

incr= fig_size + [2*opt.WindowBorder(1) sum(opt.WindowBorder)];
fig_pos= opt.DesktopBorder([1 2]) + opt.WindowBorder([1 1]) + [ih iv].*incr;
figure(opt.Fn);
if opt.ToolsOff,
  fig_toolsoff;
end
fig_size_orig= fig_size;
fig_size= round(fig_size .* opt.Resize);
if opt.ShiftUpwards && fig_size(2)~=fig_size_orig(2),
  fig_pos(2)= fig_pos(2) + fig_size_orig(2) - fig_size(2);
end
drawnow;
set(opt.Fn, 'Position', [fig_pos fig_size]);

if ~isdefault.Name,
  set(opt.Fn, 'Name',opt.Name);
end
if ~isempty(opt.Props),
  set(opt.Fn, opt.Props{:});
end
if opt.Clf,
  clf;
end