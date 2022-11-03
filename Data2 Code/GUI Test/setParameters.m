clear all;close all;clc

% Used to set all default parameters and constant parameters in the main
% file

mParams.Constant.fs = 1000;
mParams.Constant.SignalCode = containers.Map({'BP','ECG','ICGdzdt','BCG','PPGfinger','PPGear','PPGfeet','PPGtoe'},{1,2,3,3,4,4,4,4});
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
%     'maxP2VDurBCG',[-0.25,0];
%     'maxDurECGMax2BCGMax',[0.06,0.3];
    'BCGMinOffset',[0.05,0.05];
    'BCGMaxOffset',[0,0.05];
    'minPeakProminenceBCGMax',0.08;
    'minPeakProminenceBCGMin',0.02;
    'minPeakDistBCGMax',0.1;
    'minPeakDistBCGMin',0.1;
    'minPeakHeightBCGMax',-0.1;
    'minPeakHeightBCGMin',-0.1;
    'maxP2VDurPPGfinger',[-0.2,0];
    'maxDurECGMax2PPGfingerMax',[0,0.6];
    'minPeakProminencePPGfingerMax',0.2;
    'minPeakProminencePPGfingerMin',0.2;
    'minPeakDistPPGfingerMax',0.2;
    'minPeakDistPPGfingerMin',0.1;
    'minPeakHeightPPGfingerMax',0;
    'minPeakHeightPPGfingerMin',0;
    'maxP2VDurPPGear',[-0.3,0];
    'maxDurECGMax2PPGearMax',[0,0.4];
    'minPeakProminencePPGearMax',0.1;
    'minPeakProminencePPGearMin',0.1;
    'minPeakDistPPGearMax',0.2;
    'minPeakDistPPGearMin',0.1;
    'minPeakHeightPPGearMax',0;
    'minPeakHeightPPGearMin',0;
    'maxP2VDurPPGfeet',[-0.4,0];
    'maxDurECGMax2PPGfeetMax',[0,0.4];
    'minPeakProminencePPGfeetMax',0.2;
    'minPeakProminencePPGfeetMin',0.2;
    'minPeakDistPPGfeetMax',0.2;
    'minPeakDistPPGfeetMin',0.1;
    'minPeakHeightPPGfeetMax',0;
    'minPeakHeightPPGfeetMin',0;
    'maxP2VDurPPGtoe',[-0.3,0];
    'maxDurECGMax2PPGtoeMax',[0,0.5];
    'minPeakProminencePPGtoeMax',0.1;
    'minPeakProminencePPGtoeMin',0.1;
    'minPeakDistPPGtoeMax',0.2;
    'minPeakDistPPGtoeMin',0.1;
    'minPeakHeightPPGtoeMax',0;
    'minPeakHeightPPGtoeMin',0;
    'minPeakDistICGdzdt',0.4;
    'minPeakProminenceICGdzdt',0.2;
    'minPeakHeightICGdzdt',0;
    'maxDurECGMax2ICGdzdtMax',[0,0.3];
    };

% maxP2VDurBCG2=[0,0.3];
defaultParams = containers.Map(temp(:,1),temp(:,2),'UniformValues',false);

defaultParamsCopy=copy(defaultParams); %% The copy() function is used to only copy the value of containers.Map (containers.Map is a handle)
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.1;defaultParamsCopy('maxDurECGMax2PPGtoeMax')=[0,0.6];defaultParamsCopy('minPeakDistBPMax')=0.3;
defaultParamsCopy('minPeakDistPPGtoeMax')=0.4;defaultParamsCopy('minPeakHeightBPMin')=-150;
defaultParamsCopy('minPeakProminenceBPMax')=10;defaultParamsCopy('minPeakProminenceBPMin')=10;defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
defaultParamsCopy('minPeakDistPPGtoeMin')=0.1;defaultParamsCopy('minPeakProminenceBCGMax')=0.1;
mParams.DefaultValue.Subject8=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakProminenceBCGMax')=0.05;defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.2,0];defaultParamsCopy('maxP2VDurPPGfinger')=[-0.3,0];
defaultParamsCopy('minPeakProminenceECG')=0.1;defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;
mParams.DefaultValue.Subject9=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.35,0];defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.2,0];defaultParamsCopy('minPeakProminenceBCGMax')=0.05;
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('maxP2VDurPPGfinger')=[-0.45,0];defaultParamsCopy('maxP2VDurPPGear')=[-0.45,0];
defaultParamsCopy('maxP2VDurPPGtoe')=[-0.45,0];defaultParamsCopy('minPeakProminenceBCGMin')=0.003;
mParams.DefaultValue.Subject10=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.08;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.08;defaultParamsCopy('maxP2VDurPPGfinger')=[-0.3,0];
defaultParamsCopy('minPeakDistPPGfingerMin')=0.2;defaultParamsCopy('minPeakProminenceBCGMax')=0.04;
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakHeightBPMin')=-150;defaultParamsCopy('minPeakHeightBPMax')=50;
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];
mParams.DefaultValue.Subject12=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakHeightBPMin')=-150;
defaultParamsCopy('maxP2VDurPPGear')=[-0.2,0];defaultParamsCopy('minPeakProminencePPGfingerMax')=0.4;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.4;
mParams.DefaultValue.Subject13=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxDurECGMax2PPGtoeMax')=[0,0.5];defaultParamsCopy('minPeakDistBCGMax')=0.1;
defaultParamsCopy('minPeakProminencePPGearMax')=0.004;defaultParamsCopy('maxP2VDurPPGear')=[-0.25,0];defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.2,0];
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.3,0];defaultParamsCopy('minPeakProminencePPGfingerMax')=0.2;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.2;
defaultParamsCopy('maxP2VDurPPGtoe')=[-0.25,0];defaultParamsCopy('minPeakProminenceBPMin')=3;
mParams.DefaultValue.Subject14=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakDistECG')=0.3;defaultParamsCopy('minPeakDistICGdzdt')=0.3;defaultParamsCopy('minPeakDistBPMax')=0.4;
defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('maxP2VDurBP')=[-0.25,0];defaultParamsCopy('minPeakProminenceBPMin')=2;
defaultParamsCopy('minPeakHeightBPMax')=50;defaultParamsCopy('minPeakProminenceECG')=0.1;defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.2,0];
defaultParamsCopy('maxDurECGMax2PPGfingerMax')=[0,0.6];defaultParamsCopy('maxP2VDurPPGfinger')=[-0.32,0];defaultParamsCopy('maxP2VDurPPGtoe')=[-0.35,0];
defaultParamsCopy('maxP2VDurPPGear')=[-0.35,0];defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakProminenceBCGMax')=0.02;
mParams.DefaultValue.Subject19=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakProminenceECG')=0.05;defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.2,0];defaultParamsCopy('minPeakDistECG')=0.3;
defaultParamsCopy('minPeakDistICGdzdt')=0.3;defaultParamsCopy('maxP2VDurPPGfinger')=[-0.35,0];defaultParamsCopy('maxP2VDurBP')=[-0.4,0];
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakProminencePPGtoeMax')=0.08;
defaultParamsCopy('minPeakProminenceBCGMin')=0.01;defaultParamsCopy('minPeakHeightBPMin')=-150;
mParams.DefaultValue.Subject20=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakProminenceECG')=0.1;
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.1;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.1;defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;
defaultParamsCopy('minPeakDistPPGfingerMin')=0.2;defaultParamsCopy('minPeakProminencePPGtoeMax')=0.05;defaultParamsCopy('maxP2VDurPPGtoe')=[-0.2,0];
mParams.DefaultValue.Subject21=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakDistBCGMax')=0.1;defaultParamsCopy('minPeakProminenceECG')=0.07;defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.35,0];
defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('minPeakProminenceBPMax')=10;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakHeightBPMax')=30;defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakProminencePPGfingerMax')=0.15;
defaultParamsCopy('minPeakProminencePPGfingerMin')=0.15;defaultParamsCopy('maxP2VDurPPGfinger')=[-0.3,0];defaultParamsCopy('maxDurECGMax2PPGfingerMax')=[0,0.7];
defaultParamsCopy('minPeakDistPPGfingerMin')=0.3;defaultParamsCopy('minPeakProminencePPGearMax')=0.08;defaultParamsCopy('maxDurECGMax2PPGtoeMax')=[0.1,0.45];
defaultParamsCopy('minPeakDistPPGtoeMax')=0.2;defaultParamsCopy('maxP2VDurPPGtoe')=[-0.3,0];defaultParamsCopy('minPeakDistPPGtoeMin')=0.1;
defaultParamsCopy('minPeakProminencePPGtoeMin')=0.07;defaultParamsCopy('minPeakDistPPGfeetMin')=0.1;defaultParamsCopy('minPeakProminencePPGfeetMin')=0.1;
defaultParamsCopy('maxP2VDurPPGfeet')=[-0.2,0];
mParams.DefaultValue.Subject22=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakProminenceECG')=0.05;defaultParamsCopy('minPeakProminenceBCGMax')=0.04;defaultParamsCopy('minPeakProminencePPGfingerMax')=0.3;
defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakDistECG')=0.25;
defaultParamsCopy('minPeakDistICGdzdt')=0.25;defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];defaultParamsCopy('maxDurECGMax2PPGearMax')=[0,0.5];
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('maxDurECGMax2PPGfeetMax')=[0,0.5];defaultParamsCopy('minPeakHeightBPMin')=-160;
mParams.DefaultValue.Subject24=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('minPeakProminenceECG')=0.1;
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.05;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
mParams.DefaultValue.Subject27=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.05;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakProminencePPGearMax')=0.03;defaultParamsCopy('minPeakProminencePPGearMin')=0.03;
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.01;defaultParamsCopy('minPeakProminencePPGtoeMin')=0.01;
mParams.DefaultValue.Subject28=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=3;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.05;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakProminencePPGearMax')=0.05;defaultParamsCopy('minPeakProminencePPGearMin')=0.05;
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.05;defaultParamsCopy('minPeakProminencePPGtoeMin')=0.05;
mParams.DefaultValue.Subject29=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminenceBCGMax')=0.05;defaultParamsCopy('minPeakProminenceBCGMin')=0.03;
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.05;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakProminencePPGearMax')=0.05;defaultParamsCopy('minPeakProminencePPGearMin')=0.05;
defaultParamsCopy('minPeakProminencePPGfeetMax')=0.1;defaultParamsCopy('minPeakProminencePPGfeetMin')=0.1;
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.05;defaultParamsCopy('minPeakProminencePPGtoeMin')=0.05;
mParams.DefaultValue.Subject30=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminenceBCGMax')=0.05;defaultParamsCopy('minPeakProminenceBCGMin')=0.02;
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.05;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakProminencePPGearMax')=0.05;defaultParamsCopy('minPeakProminencePPGearMin')=0.05;
defaultParamsCopy('minPeakProminencePPGfeetMax')=0.1;defaultParamsCopy('minPeakProminencePPGfeetMin')=0.1;
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.05;defaultParamsCopy('minPeakProminencePPGtoeMin')=0.05;
mParams.DefaultValue.Subject31=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
mParams.DefaultValue.Subject33=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
mParams.DefaultValue.Subject34=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
mParams.DefaultValue.Subject36=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
mParams.DefaultValue.Subject37=defaultParamsCopy;

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.03; defaultParamsCopy('minPeakProminencePPGtoeMin')=0.02;
mParams.DefaultValue.Subject601=defaultParamsCopy; % subject 006-2

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('maxDurECGMax2PPGfeetMax')=[0,0.5];
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.03; defaultParamsCopy('minPeakProminencePPGtoeMin')=0.02;
mParams.DefaultValue.Subject801=defaultParamsCopy; % subject 008-2

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;
defaultParamsCopy('minPeakProminenceBPMax')=15;defaultParamsCopy('minPeakProminenceBPMin')=5;
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('maxDurECGMax2PPGfeetMax')=[0,0.5];
defaultParamsCopy('minPeakProminencePPGtoeMax')=0.03; defaultParamsCopy('minPeakProminencePPGtoeMin')=0.02;
mParams.DefaultValue.Subject701=defaultParamsCopy; % subject 007-2

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
defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
defaultParamsCopy('minPeakProminenceBCGMax')=0.003;defaultParamsCopy('minPeakProminenceBCGMin')=0.002;
defaultParamsCopy('minPeakDistBCGMax')=0.05;defaultParamsCopy('minPeakDistBCGMin')=0.05;
defaultParamsCopy('BCGMaxOffset')=[-0.01,0.05];defaultParamsCopy('BCGMinOffset')=[-0.01,0.05];
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.4;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
mParams.DefaultValue.Subject100=defaultParamsCopy; %S25_RAW

defaultParamsCopy=copy(defaultParams);
defaultParamsCopy('maxP2VDurBP')=[-0.3,0];defaultParamsCopy('minPeakDistBPMax')=0.3;defaultParamsCopy('minPeakDistBPMin')=0.1;defaultParamsCopy('minPeakHeightBPMax')=40;
defaultParamsCopy('minPeakProminenceBPMax')=5;defaultParamsCopy('minPeakProminenceBPMin')=5;defaultParamsCopy('peakStdWindowSize')=250;
defaultParamsCopy('maxDurBPMin2ECGMax')=[-0.3,0];
defaultParamsCopy('minPeakProminenceBCGMax')=0.002;defaultParamsCopy('minPeakProminenceBCGMin')=0.002;
defaultParamsCopy('minPeakDistBCGMax')=0.05;defaultParamsCopy('minPeakDistBCGMin')=0.05;
defaultParamsCopy('BCGMaxOffset')=[-0.01,0.05];defaultParamsCopy('BCGMinOffset')=[-0.01,0.05];
defaultParamsCopy('maxP2VDurPPGfinger')=[-0.4,0];defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
defaultParamsCopy('minPeakProminencePPGfingerMax')=0.4;defaultParamsCopy('minPeakProminencePPGfingerMin')=0.05;
defaultParamsCopy('minPeakDistPPGfingerMax')=0.2;defaultParamsCopy('minPeakDistPPGfingerMin')=0.05;
mParams.DefaultValue.Subject101=defaultParamsCopy; %S27_RAW

save mParams mParams