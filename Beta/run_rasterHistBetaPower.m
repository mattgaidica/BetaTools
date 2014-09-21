%plot(wavefilter(double(NS5.Data(1,1:100000)),5))
%
samples = 1e6;
channels = [6 7 8 9];
combinedSpikePhases = [];
for i=1:length(channels)
    spikeVector = [];
    allBeta = [];
    allSpikes = [];

    disp(strcat('channel:',num2str(channels(i))));
    data = double(NS5.Data(channels(i),1:samples));
    HPdata = wavefilter(data,5);
    locs = absPeakDetection(HPdata);
    spikeVector = locs*(3e4^-1);
    %spikeVector = horzcat(spikeVector,allSpikes);
    
    [t,f,Snorm]=betaspec(data);
    cSnorm = normalize(mean(Snorm)); %normalized(0-1)-compressed Snorm
    %allBeta(i,:) = cSnorm(1,:);

    meanBeta = mean(cSnorm,1);

    xend = samples/3e4;
    figure;

    % subplot(4,1,1);
    % plotSpikeRaster(allSpikes');
    % xlim([0 xend]);
    % title('All Spikes Raster');
    % ylabel('channel');

    subplot(3,1,1);
    hist(spikeVector,300);
    xlim([0 xend]);
    title('All Spikes Histogram (300 bins)');
    ylabel('spike count');

    subplot(3,1,2);
    plot(t,meanBeta);
    hold on;
    plot(t,smooth(meanBeta,15),'r');
    xlim([0 xend]);
    title('Beta Power (13-30Hz)');
    ylabel('normalized power');

    subplot(3,1,3);
    imagesc(t,f,Snorm);
    xlim([0 xend]);
    title('Beta Spectrogram (13-30Hz)');
    ylabel('frequency');

    xlabel(strcat('time (s)--','channel:',num2str(channels(i))));

    threshCrossTimes = getThreshCrossTimes(meanBeta); %thresh set in function

    % % figure;
    % % plot(meanBeta);
    % % hold on;
    % % for i=1:length(threshCrossTimes)
    % %     plot(threshCrossTimes{i},meanBeta(threshCrossTimes{i}),'r');
    % % end
    % % hold off;

    %[b,a]=butter(4,2*30*2/3e4,'low'); %how to do bandpass of 13-30?
    Hbp = bandpassFilt;
    spikePhases = [];
    for j=1:length(threshCrossTimes)
        t1 = t(threshCrossTimes{j}(1));
        t2 = t(threshCrossTimes{j}(end));
        if(t1==t2),continue,end; %for single value entries, could fix in function itself
        trialData = extractdatac(data,3e4,[t1 t2]);
        range = 0:3e4^-1:(3e4^-1)*(length(trialData)-1);
        trialDataLP = filter(Hbp,trialData);
        f = fit(range',trialDataLP,'sin1');
%         figure;
%         plot(f,range',trialDataLP);
        amplitude = f.a1;
        frequency = f.b1; %/(2*pi)
        phase = f.c1; %rad2deg()

        spikes = extractdatapt(spikeVector,[t1 t2],1); %(x,x,1) zeros them to this trial
        %hold on;plot(spikeTimes.times,zeros(1,length(spikeTimes.times)),'o');
        f = frequency/(2*pi);

        for k=1:length(spikes.times)
            spikePhase = atan2(sin(frequency*spikes.times(k)+phase),cos(frequency*spikes.times(k)+phase));
            spikePhases = horzcat(spikePhases,spikePhase);
        end
    end
    figure;
    rose(spikePhases);
    title(strcat('channel:',num2str(channels(i))));
    combinedSpikePhases = horzcat(combinedSpikePhases,spikePhases);
end

figure;
rose(combinedSpikePhases);
title('all spike phases');