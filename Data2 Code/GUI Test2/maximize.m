function maximize(varargin)
% Maximize figure window size to screen size
%
% maximize() : maximizes gcf
% maximize(h) : maximizes figure window described in figure handler h
%
% Usage :
% fh = figure();
% maximize(fh);
%
menubar_px = 120;
taskbar_px = 40;

if isempty(varargin)
    scrsz = get(groot,'ScreenSize');
    set(gcf,'Position',[1 scrsz(2)+taskbar_px scrsz(3) scrsz(4)-menubar_px]);
else
    scrsz = get(groot,'ScreenSize');
    set(varargin{1},'Position',[1 scrsz(2)+taskbar_px scrsz(3) scrsz(4)-menubar_px]);
end