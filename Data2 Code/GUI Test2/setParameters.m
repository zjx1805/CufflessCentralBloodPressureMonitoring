clear all;close all;clc

% Used to set all default parameters and constant parameters in the main
% file

mParams.Constant.fs = 1000;
mParams.Constant.fs_IR = 250;
mParams.Constant.SignalCode = containers.Map({'BP','ECG','BCGScale','BCGWrist','BCGArm','BCGNeck','PPGClip','PPGIR','PPGGreen'},{1,2,3,3,3,3,4,4,4});
mParams.Constant.InterventionName2Idx = containers.Map({'BL','SB','MA','CP','PE','HRL','HB'},[0,1,2,3,4,5,2]);
mParams.Constant.SlidingWindowSize = 10;
mParams.Constant.MinPanValue = 5; %[sec]
mParams.Constant.MaxPanValue = 20; %[sec]
temp={...
    'minPeakHeightBPMin',-120;
    'minPeakHeightBPMax',70;
    'minPeakProminenceBPMax',10;
    'minPeakProminenceBPMin',5;
    'maxP2VDurBP',[-0.2,0];
    'maxDurBPMin2ECGMax',[-0.2,0];
    'minPeakDistBPMax',0.4;
    'minPeakDistBPMin',0.4;
    'peakStdThreshold',1.5;
    'peakStdWindowSize',180;
    'minPeakProminenceECG',0.2;
    'minPeakDistECG',0.4;
    'minPeakHeightECG',0;

    'BCGScaleHOffset',[-0.01,0];
    'BCGScaleIOffset',[-0.01,0.05];
    'BCGScaleJOffset',[-0.01,0.05];
    'BCGScaleKOffset',[0,0.05];
    'BCGScaleLOffset',[0,0.05];
    'minPeakProminenceBCGScaleH',0.001;
    'minPeakProminenceBCGScaleI',0.002;
    'minPeakProminenceBCGScaleJ',0.002;
    'minPeakProminenceBCGScaleK',0.001;
    'minPeakProminenceBCGScaleL',0.001;
    'minPeakDistBCGScaleH',0.05;
    'minPeakDistBCGScaleI',0.05;
    'minPeakDistBCGScaleJ',0.05;
    'minPeakDistBCGScaleK',0.05;
    'minPeakDistBCGScaleL',0.05;
    'minPeakHeightBCGScaleH',-0.1;
    'minPeakHeightBCGScaleI',-0.1;
    'minPeakHeightBCGScaleJ',-0.1;
    'minPeakHeightBCGScaleK',-0.1;
    'minPeakHeightBCGScaleL',-0.1;
    
    'BCGArmHOffset',[-0.01,0];
    'BCGArmIOffset',[-0.01,0.05];
    'BCGArmJOffset',[-0.01,0.05];
    'BCGArmKOffset',[0,0.05];
    'BCGArmLOffset',[0,0.05];
    'minPeakProminenceBCGArmH',0.002;
    'minPeakProminenceBCGArmI',0.005;
    'minPeakProminenceBCGArmJ',0.01;
    'minPeakProminenceBCGArmK',0.01;
    'minPeakProminenceBCGArmL',0.002;
    'minPeakDistBCGArmH',0.05;
    'minPeakDistBCGArmI',0.05;
    'minPeakDistBCGArmJ',0.05;
    'minPeakDistBCGArmK',0.05;
    'minPeakDistBCGArmL',0.05;
    'minPeakHeightBCGArmH',-0.1;
    'minPeakHeightBCGArmI',-0.1;
    'minPeakHeightBCGArmJ',-0.1;
    'minPeakHeightBCGArmK',-0.1;
    'minPeakHeightBCGArmL',-0.1;
    
    'maxP2VDurPPGClip',[-0.3,0];
    'maxDurECGMax2PPGClipMax',[0,0.6];
    'minPeakProminencePPGClipMax',0.4;
    'minPeakProminencePPGClipMin',0.1;
    'minPeakDistPPGClipMax',0.2;
    'minPeakDistPPGClipMin',0.1;
    'minPeakHeightPPGClipMax',0;
    'minPeakHeightPPGClipMin',0;
    };

% maxP2VDurBCG2=[0,0.3];
defaultParams = containers.Map(temp(:,1),temp(:,2),'UniformValues',false);



% defaultParamsCopy=copy(defaultParams);
% defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('minPeakHeightBPMax')=40;
% defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('peakStdWindowSize')=250;
% defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
% defaultParamsCopy('minPeakProminenceBCGMax')=0.005;defaultParamsCopy('minPeakProminenceBCGMin')=0.002;
% defaultParamsCopy('minPeakDistBCGMax')=0.05;defaultParamsCopy('minPeakDistBCGMin')=0.05;
% defaultParamsCopy('BCGMaxOffset')=[0.04,0.15];defaultParamsCopy('BCGMinOffset')=[0.05,0.2];
% defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
% defaultParamsCopy('minPeakProminencePPGfingerMax')=0.4;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
% defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
% mParams.DefaultValue.Subject100=defaultParamsCopy; %S25_RAW BCGInverted
% 
% defaultParamsCopy=copy(defaultParams);
% defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('minPeakHeightBPMax')=40;
% defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('peakStdWindowSize')=250;
% defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
% defaultParamsCopy('minPeakProminenceBCGMax')=0.002;defaultParamsCopy('minPeakProminenceBCGMin')=0.002;
% defaultParamsCopy('minPeakDistBCGMax')=0.05;defaultParamsCopy('minPeakDistBCGMin')=0.05;
% defaultParamsCopy('BCGMaxOffset')=[0.04,0.15];defaultParamsCopy('BCGMinOffset')=[0.07,0.2];
% defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
% defaultParamsCopy('minPeakProminencePPGfingerMax')=0.4;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
% defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
% mParams.DefaultValue.Subject101=defaultParamsCopy; %S27_RAW BCGInverted

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('minPeakHeightBPMax')=40;
defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('peakStdWindowSize')=250;
defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];defaultParamsCopy('minPeakProminenceBCGArmJ')=0.005;
mParams.DefaultValue.Subject100=defaultParamsCopy; %S25_RAW

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('minPeakHeightBPMax')=40;
defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('peakStdWindowSize')=250;
defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
mParams.DefaultValue.Subject101=defaultParamsCopy; %S27_RAW

save mParams mParams