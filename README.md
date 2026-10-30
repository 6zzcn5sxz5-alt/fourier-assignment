# Lecture 5: Fourier Series, DTFT and DFT (MATLAB)

This repository contains four MATLAB exercises. Each `exerciseN.m` script saves its plots as PNG files in the same exercise folder.

> **Before submitting:** These are **draft explanations and reference figures** prepared with AI assistance. Run all four `.m` scripts yourself in MATLAB, check the saved figures against the discussion below, and rewrite the explanations in your own words. The included PNGs were initially produced with an equivalent independent numerical calculation, not by a MATLAB run.

## How to run

1. Open MATLAB and navigate to the repository folder.
2. Open `exercise-1/exercise1.m` and click **Run**. Repeat for Exercises 2, 3 and 4.
3. Inspect the generated plots and any printed numbers in the Command Window.
4. Confirm that `d = 0` in Exercise 3 is the last digit of your own student number.
5. Save the updated PNGs, replace the draft wording with your own interpretation, and push the final files to GitHub.

## Exercise 1: Build a square wave from harmonics

**Prediction before running:** A single sine wave will look smooth. When higher odd harmonics are added, the upper and lower parts should become flatter and the edges should become steeper. Some ripples may appear around the jumps.

**Method:** The Fourier approximation is

\[
x_H(t)=\frac{4}{\pi}\sum_{k=1,3,5,\ldots,H}\frac{\sin(2\pi k t)}{k}.
\]

The tested highest odd harmonics are **H = 1, 3, 9, 25**.

![Square wave comparison](exercise-1/square-wave-comparison.png)

**What changes:** At H = 1 the result is only a sine wave. At H = 3 it begins to resemble a square wave. At H = 9 and H = 25, the flat sections improve and transitions become narrower. The waves at the transitions do not completely disappear. The overshoot and small oscillations near a discontinuity are known as the **Gibbs phenomenon**. The overshoot becomes concentrated in a narrower region as more harmonics are used; its relative height does not go to zero.

## Exercise 2: Find two frequencies with the FFT

**Prediction before running:** The input contains **15 Hz with amplitude 0.8** and **40 Hz with amplitude 0.4**. The amplitude spectrum should have strong peaks at those two frequencies.

The sampling rate is `fs = 200 Hz`, the duration is `T = 1 s`, and the sample count is `N = fs × T = 200`.

**Frequency-bin spacing:**

\[
\Delta f=\frac{f_s}{N}=\frac{200}{200}=\boxed{1\text{ Hz}}.
\]

![Time-domain signal](exercise-2/two-frequency-time-domain.png)

![Two-frequency amplitude spectrum](exercise-2/two-frequency-spectrum.png)

**Expected FFT results (cross-checked numerically):**

| Component | Input frequency | Input amplitude | FFT-bin frequency | Single-sided FFT amplitude |
|---|---:|---:|---:|---:|
| First | 15 Hz | 0.8 | 15 Hz | ≈ 0.800 |
| Second | 40 Hz | 0.4 | 40 Hz | ≈ 0.400 |

**Explanation:** Both sinusoids complete a whole number of cycles in one second, so their frequencies fall exactly on DFT bins. The single-sided spectrum doubles the interior bins after normalization by `N`, recovering the amplitudes 0.8 and 0.4 (up to floating-point roundoff). The time-domain plot looks more complicated because the two waves are added together.

## Exercise 3: Investigate spectral leakage

**Last student-number digit:** `d = 0` (verify before submission; full student number intentionally omitted).

**Changed frequency:**

\[
f_2=13.2+0.17d=13.2+0.17(0)=\boxed{13.20\text{ Hz}}.
\]

**Prediction before running:** In a one-second recording, 13.2 Hz does not match the 1-Hz DFT grid. Instead of one sharp line at 13.2 Hz, energy will spread across neighboring frequency bins. The 15-Hz component is still present, but leakage can also affect its measured bin magnitude.

![Comparison of leakage spectra](exercise-3/leakage-comparison.png)

The individual figures are [one second](exercise-3/leakage-1-second.png), [four seconds](exercise-3/leakage-4-seconds.png) and [one second with zero-padding](exercise-3/leakage-zero-padded.png).

| Case | Original samples | True record-based spacing `fs/N` | Spacing between plotted FFT values | Observation |
|---|---:|---:|---:|---|
| 1-second FFT | 200 | 1 Hz | 1 Hz | Broad, discrete leakage pattern around 13.2 Hz |
| 4-second FFT | 800 | 0.25 Hz | 0.25 Hz | Narrower peak and better frequency discrimination |
| 1-second FFT, padded 4× | 200 | 1 Hz | 0.25 Hz | Smoother sampling of the **same** one-second spectrum |

**Numerical cross-check:** For the one-second FFT, the 13-Hz bin is about 0.372, while the 15-Hz bin is about 0.765. In the four-second FFT, the 13.25-Hz bin is about 0.374 and the 15-Hz bin is about 0.809. These values are not necessarily equal to the original component amplitudes, because the non-grid-aligned tone leaks and the two spectral contributions interact.

**Explanation:** Spectral leakage occurs because taking a finite recording is equivalent to multiplying the infinite-duration signal by a rectangular window. A longer recording makes the main spectral lobe narrower and improves the ability to distinguish close frequencies. Zero-padding adds zeros **after recording**; it evaluates the same underlying spectrum at more plotted frequencies but does not create new observed signal samples or improve the physical frequency resolution of the one-second recording.

## Exercise 4: Compare the DTFT and DFT

The original sequence is `x = [1 1 1 1]`, so it has **four** actual time samples. Its DTFT is

\[
X(e^{j\omega})=1+e^{-j\omega}+e^{-j2\omega}+e^{-j3\omega}.
\]

![DTFT and DFT comparison](exercise-4/dtft-dft-comparison.png)

**Task 4 — compare the curves:** The DTFT is a continuous function of angular frequency; plotting it at 1000 points makes a smooth-looking curve. The DFT consists of samples of the same frequency response at equally spaced angular frequencies. A 4-point DFT shows only four samples (one is DC with magnitude 4 and the others are zero). A 64-point DFT samples the curve much more densely, so its points trace the DTFT shape more clearly.

**Task 5 — why 64 FFT points:** `fft(x,64)` automatically appends **60 zeros** to the four original samples before computing the FFT. The frequency-grid spacing changes from `2*pi/4 = pi/2` to `2*pi/64 = pi/32` rad/sample. No new measured or original time-domain samples are added; zero-padding only gives more frequency samples of the DTFT.

**Task 6 — zeros:** The magnitude is zero at **ω = ±π/2 and ±π rad/sample** within the plotted interval from -π to π (the two endpoints represent the same angular frequency). The DTFT plot approaches zero at these positions; the 1000-point plotting grid does not necessarily land exactly on all of them.


