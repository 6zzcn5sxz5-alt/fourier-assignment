% Exercise 3: Leakage, longer observation, and zero-padding.
% The LAST DIGIT of the student number is used (not the full number).
clear; close all; clc;

fs = 200;
d = 0;                         % Confirm your own last student-number digit!
f2 = 13.2 + 0.17*d;
durations = [1, 4];

outputDir = fileparts(mfilename('fullpath'));
if isempty(outputDir), outputDir = pwd; end

allF = cell(1, 3);
allP = cell(1, 3);
labels = {'1-second recording', '4-second recording', ...
          '1-second recording, 4x zero-padded FFT'};
fileNames = {'leakage-1-second.png', 'leakage-4-seconds.png', ...
             'leakage-zero-padded.png'};

for i = 1:2
    T = durations(i);
    t = 0:1/fs:T-1/fs;
    x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*f2*t);
    [allF{i}, allP{i}] = oneSidedSpectrum(x, fs, length(x));
    fprintf('%g-second record: N = %d, bin spacing = %.3f Hz\n', ...
        T, length(x), fs/length(x));

    if i == 1
        % Zero-pad the SAME one-second samples to four times their length.
        [allF{3}, allP{3}] = oneSidedSpectrum(x, fs, 4*length(x));
    end
end

for i = 1:3
    fig = figure('Color', 'w', 'Position', [100 100 1000 470]);
    plot(allF{i}, allP{i}, 'b', 'LineWidth', 1.15);
    grid on;
    xlim([8 20]);
    ylim([0 0.95]);
    xlabel('Frequency (Hz)');
    ylabel('Single-sided amplitude');
    title(sprintf('%s (f2 = %.2f Hz)', labels{i}, f2));
    saveas(fig, fullfile(outputDir, fileNames{i}));
end

figAll = figure('Color', 'w', 'Position', [70 70 1050 800]);
for i = 1:3
    subplot(3, 1, i);
    plot(allF{i}, allP{i}, 'b', 'LineWidth', 1.1);
    grid on;
    xlim([8 20]);
    ylim([0 0.95]);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    title(labels{i});
end
sgtitle(sprintf('Spectral leakage comparison: d = %d, f2 = %.2f Hz', d, f2));
saveas(figAll, fullfile(outputDir, 'leakage-comparison.png'));
fprintf('f2 = %.3f Hz. Zero-padded plotted-bin spacing = %.3f Hz.\n', ...
    f2, allF{3}(2)-allF{3}(1));
disp('Exercise 3 completed: three separate spectra and comparison saved.');

function [f, P1] = oneSidedSpectrum(x, fs, nfft)
    % Normalize by the ORIGINAL data length, not the padded FFT length.
    N = length(x);
    Y = fft(x, nfft);
    P2 = abs(Y/N);
    P1 = P2(1:nfft/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:nfft/2)/nfft;
end
