Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 2*3e4; % Length of signal
t = (0:L-1)*T; % Time vector
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

thresh = 1e4;
chopSamples = L; %Xs @ 30kS/s
pieces = findCleanSpans(allData,thresh,chopSamples);

allBetaP = [];
for i=1:length(pieces)
    disp([num2str(i/length(pieces)*100),'%']);
    Y = fft(double(allData(pieces(i,1):pieces(i,2))),NFFT)/L;
    A = 2*abs(Y(1:NFFT/2+1));

    fLow = 12;
    fHigh = 20;
    [~,fIdx]=find(f>=fLow & f<=fHigh);
    betaP = mean(A(fIdx));
    allBetaP = [allBetaP betaP];
end
ketaminePiece = max(find(pieces(:,1)<ketamineSample));
figure;
plot(1:ketaminePiece,allBetaP(1:ketaminePiece));
hold on;
plot(ketaminePiece:length(pieces),allBetaP(ketaminePiece:end),'r');

nextThresh = 200;
nextIdxs = find(allBetaP>nextThresh);
allWaits = [];
for i=1:length(pieces)-1
    nextMin = find(nextIdxs>i,1);
    if(~isempty(nextMin))
        allWaits(i) = nextIdxs(nextMin)-i;
    end
end

figure;
plot(1:ketaminePiece,allWaits(1:ketaminePiece));
hold on;
plot(ketaminePiece:length(allWaits),allWaits(ketaminePiece:end),'r');
% figure;
% allBetaPSmooth = smooth(allBetaP,50);
% figure;
% plot(1:ketaminePiece,allBetaPSmooth(1:ketaminePiece));
% hold on;
% plot(ketaminePiece:length(pieces),allBetaPSmooth(ketaminePiece:end),'r');

% Plot single-sided amplitude spectrum.
% plot(f,A) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% xlim([0 100])
