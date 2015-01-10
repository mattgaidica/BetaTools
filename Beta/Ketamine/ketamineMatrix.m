function [allMatrices,filePieces]=ketamineMatrix(nsxFiles,usefilter)
    filePieces = {};
    allMatrices = [];
    pieceCount = 1;
    thresh = 2e4;
    chopSamples = 5*3e4; %5s @ 30kS/s
    
    for i=1:length(nsxFiles)
        disp(nsxFiles(i).name);
        NSx = openNSx(fullfile(beforeDir,beforeFiles(i).name),'read');
        % could average data first, assumes ch1 is representative
        pieces = findCleanSpans(NSx.Data(1,:),thresh,chopSamples);
        disp(['pieces:',num2str(length(pieces))]);
        filePieces{pieceCount} = {nsxFiles(i).name,pieces};
        hbar = waitbar(0,beforeFiles(i).name);
        for j=1:length(pieces)
            hbar = waitbar(j/length(pieces),hbar);
            dataM1 = NSx.Data(1:16,pieces(j,1):pieces(j,2));
            dataS1 = NSx.Data(end-15:end,pieces(j,1):pieces(j,2));

            [phasesS1,~] = extractBandpassPhase(dataS1,usefilter);
            [phasesM1,~] = extractBandpassPhase(dataM1,usefilter);

            allMatrices(pieceCount,:,:) = zeros(16);
            for s1i=1:16
                for m1i=1:16
                    [r,p] = corrcoef(phasesS1(s1i,:),phasesM1(m1i,:));
                    allMatrices(pieceCount,s1i,m1i) = r(1,2);
                end
            end
            pieceCount = pieceCount+1;
        end
        close(hbar);
    end
    
end