clear all;close all;clc;

allIndexes = [8,9,10,12,13,14,19,20,21,22,24,27,28,29];
SPTotal = []; DPTotal = [];
for ii = 1:length(allIndexes)
    currentIdx = allIndexes(ii);
    load(['Subject' num2str(currentIdx) 'Data.mat'])
    PAT = mResults.Result.PAT;
    PTT = mResults.Result.PTT;
    IJInfo = mResults.Result.IJInfo;
    SPTotal(1:13,currentIdx)=[PAT.PPGfingerECG.correlation(1);PAT.PPGearECG.correlation(1);PAT.PPGfeetECG.correlation(1);PAT.PPGtoeECG.correlation(1);
        PTT.PPGfingerICG.correlation(1);PTT.PPGearICG.correlation(1);PTT.PPGfeetICG.correlation(1);PTT.PPGtoeICG.correlation(1);
        PTT.PPGfingerBCG.correlation(1);PTT.PPGearBCG.correlation(1);PTT.PPGfeetBCG.correlation(1);PTT.PPGtoeBCG.correlation(1);
        IJInfo.correlation(1)];
    DPTotal(1:13,currentIdx)=[PAT.PPGfingerECG.correlation(2);PAT.PPGearECG.correlation(2);PAT.PPGfeetECG.correlation(2);PAT.PPGtoeECG.correlation(2);
        PTT.PPGfingerICG.correlation(2);PTT.PPGearICG.correlation(2);PTT.PPGfeetICG.correlation(2);PTT.PPGtoeICG.correlation(2);
        PTT.PPGfingerBCG.correlation(2);PTT.PPGearBCG.correlation(2);PTT.PPGfeetBCG.correlation(2);PTT.PPGtoeBCG.correlation(2);
        IJInfo.correlation(2)];
end
SPTotalDisplay = SPTotal(:,allIndexes)
DPTotalDisplay = DPTotal(:,allIndexes)
    