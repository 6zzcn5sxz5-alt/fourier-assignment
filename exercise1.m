% Exercise 1: Build a square wave with odd Fourier harmonics.
% Run this file in MATLAB. It saves the comparison figure beside the script.
clear; close all; clc;

t = linspace(-1, 1, 4000);
harmonicLimits = [1, 3, 9, 25];

outputDir = fileparts(mfilename('fullpath'));
if isempty(outputDir), outputDir = pwd; end

fig = figure('Color', 'w', 'Position', [80 80 1000 650]);
for i = 1:length(harmonicLimits)
    H = harmonicLimits(i);
    x = zeros(size(t));

    for k = 1:2:H
        x = x + (4/pi) * sin(2*pi*k*t) / k;
    end

    subplot(2, 2, i);
    plot(t, x, 'b', 'LineWidth', 1.3);
    grid on;
    xlim([-1 1]);
    ylim([-1.4 1.4]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(sprintf('Highest odd harmonic H = %d', H));
end

sgtitle('Square-wave Fourier series: increasing odd harmonics');
saveas(fig, fullfile(outputDir, 'square-wave-comparison.png'));
disp('Exercise 1 completed: square-wave-comparison.png saved.');
