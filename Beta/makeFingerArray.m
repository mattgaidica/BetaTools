function fingerArray=makeFingerArray(z)
    fingerAngles = [];
    for i=1:length(z)
        [fingerAngles,pos] = avgFingerAngles(z(1,i));
        fingerArray(1,z(1,i).ExperimentTime) = fingerAngles;
        % removes some sharp trial-by-trial artifacts
    end
    fingerArray = medfilt1(double(fingerArray),10);
end

% makes no distinction between fingers
function [fingerAngles,pos]=avgFingerAngles(zTrial)
    % averages all unmasked (active) columns
    fingerAngles = mean(zTrial.FingerAnglesTIMRL(:,logical(zTrial.MoveMask)),2);
    % simple way to get target pos for the finger
    pos = mean(zTrial.TargetPos(:,logical(zTrial.MoveMask)));
end