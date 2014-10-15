function Hd = bandpassFilt
%BANDPASSFILT Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the Signal Processing Toolbox 6.19.
% Generated on: 20-Sep-2014 23:00:16

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 30000;  % Sampling Frequency

Fstop1 = 11;          % First Stopband Frequency
Fpass1 = 12;          % First Passband Frequency
Fpass2 = 15;          % Second Passband Frequency
Fstop2 = 16;          % Second Stopband Frequency
Astop1 = 3;           % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 3;           % Second Stopband Attenuation (dB)
match  = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% [EOF]
