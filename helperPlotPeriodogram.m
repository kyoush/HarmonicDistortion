function helperPlotPeriodogram(samples, Fs, psdesttype, annotate, shownoise)
%helperPlotPeriodogram Helper function for HarmonicDistortionExample.m
%
% This file is for internal use only and may change in a future release of
% MATLAB.

% Copyright 2013 The MathWorks, Inc.

% use consistent seed for publishing
rng default;

% get the default color order from MATLAB
colorOrder = get(0,'DefaultAxesColorOrder');

% use a Kaiser window with a fairly large bandwidth to reduce the effects
% of leakage.
nfft = size(samples,2);
window = kaiser(nfft, 38);

for i=1:size(samples,1)
  subplot(size(samples,1),1,i);
  periodogram(samples(i,:), window, nfft, Fs, psdesttype);
  lines = get(gca,'children');
  set(lines(1),'Color',colorOrder(mod(i-1,size(colorOrder,1))+1,:));
  hold on;
  if nargin>3 && strcmpi(annotate,'annotate')
    % annotate the harmonics on the graph (including the fundamental).
    [~, harmPow, harmFreq] = thd(samples(i,:), Fs, 5);
    plot(harmFreq/1e3, harmPow, 'v ','MarkerFaceColor','b');
        
    % create the harmonic table
    harmonicTable = [ ...
      {' Freq.     Power    '
       ' (kHz)  (dB)  (dBc) '}
      arrayfun(@(f,db,dbc) sprintf(' % 3.0f % 7.1f % 6.1f ',f,db,dbc), ...
        harmFreq/1e3, harmPow, harmPow-harmPow(1),'UniformOutput',false)];
      
    if nargin>4 && strcmpi(shownoise,'shownoise')
      % compute the noise power present in the signal
      [~, noisePower] = snr(samples(i,:), Fs);

      % annotate the level of the total cumulative noise on the plot
      plot([0 Fs/2]/1e3,noisePower*[1 1],'k--');
      
      table = [harmonicTable
               {''
                ' Total noise power: '
                sprintf('%.1f dB   ',noisePower)}];
    else
      table = harmonicTable;
    end
    
    % display table off to the right (ending at ~Fs/2 kHz)
    text(round(Fs/2/1e3),harmPow(1),table, ...
      'HorizontalAlignment','right', ...
      'VerticalAlignment','top', ...
      'FontName',get(0,'FixedWidthFontName'), ...
      'BackgroundColor','w', ...
      'EdgeColor','k', ...
      'Margin',1);
  end
  hold off;
  axis normal;
end