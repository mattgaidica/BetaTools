% zCAR=CAR(z,76,64);

for i=1:110
    plot(diff(zCAR(1,i).FingerAnglesTIMRL))
    pause(.15);
end

% elist = [6,7,8];
% elist = [1];
% for i=1:length(zCAR) %trials loop
%     allSnorm = [];
%     for j=1:length(elist)
%         if(~isempty(zCAR(1,i).ECoG))
%             data = zCAR(1,i).ECoG(1,elist(j)).Data;
%             [t,f,snorm] = getSpec(data);
%             allSnorm(:,:,i) = snorm;
%         end
%     end
%     disp(i)
% end

% figure;
% imagesc(t,f,mean(allSnorm,3));