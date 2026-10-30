% Exercise 4: Continuous-frequency DTFT versus DFT samples.
clear; close all; clc;

x = [1 1 1 1];
n = 0:length(x)-1;
w = linspace(-pi, pi, 1000);
X = x * exp(-1j * (n.' * w));

N4 = 4;
N64 = 64;
X4 = fftshift(fft(x, N4));
X64 = fftshift(fft(x, N64));
w4 = 2*pi*(-N4/2:N4/2-1)/N4;
w64 = 2*pi*(-N64/2:N64/2-1)/N64;

outputDir = fileparts(mfilename('fullpath'));
if isempty(outputDir), outputDir = pwd; end

fig = figure('Color', 'w', 'Position', [100 50 1000 780]);
subplot(3, 1, 1);
plot(w, abs(X), 'b', 'LineWidth', 1.5);
grid on; xlim([-pi pi]); ylim([0 4.3]);
set(gca, 'XTick', [-pi -pi/2 0 pi/2 pi]);
set(gca, 'XTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'});
xlabel('Angular frequency (rad/sample)');
ylabel('Magnitude');
title('DTFT: 1000 frequency values');

subplot(3, 1, 2);
stem(w4, abs(X4), 'filled', 'LineWidth', 1.2);
grid on; xlim([-pi pi]); ylim([0 4.3]);
set(gca, 'XTick', [-pi -pi/2 0 pi/2 pi]);
set(gca, 'XTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'});
xlabel('Angular frequency (rad/sample)');
ylabel('Magnitude');
title('4-point DFT: fft(x, 4)');

subplot(3, 1, 3);
plot(w, abs(X), 'Color', [0.75 0.75 0.75], 'LineWidth', 1.4);
hold on;
stem(w64, abs(X64), 'filled', 'Color', [0.1 0.4 0.85], 'MarkerSize', 3);
hold off;
grid on; xlim([-pi pi]); ylim([0 4.3]);
set(gca, 'XTick', [-pi -pi/2 0 pi/2 pi]);
set(gca, 'XTickLabel', {'-pi', '-pi/2', '0', 'pi/2', 'pi'});
xlabel('Angular frequency (rad/sample)');
ylabel('Magnitude');
title('64-point DFT (blue samples) and DTFT (gray curve)');

sgtitle('DTFT and DFT for x[n] = [1, 1, 1, 1]');
saveas(fig, fullfile(outputDir, 'dtft-dft-comparison.png'));
fprintf('Original sample count = %d; fft lengths = %d and %d.\n', ...
    length(x), N4, N64);
disp('DTFT zero locations in [-pi, pi]: -pi, -pi/2, pi/2, pi.');
disp('Exercise 4 completed: dtft-dft-comparison.png saved.');
