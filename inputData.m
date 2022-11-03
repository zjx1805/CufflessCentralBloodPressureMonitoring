clear all;close all;clc

eventTimes(1).ssTimeMatrix=[61.15,120;273.53,395.22;601.68,695.01;918.23,1009.37;1078.48,1169.13;2121.29,2242.95];
eventTimes(1).cpTimeMatrix=[132.01,260.01];
eventTimes(1).maTimeMatrix=[409.01,587.76];
eventTimes(1).sbTimeMatrix=[718.25,901.83];
eventTimes(1).hbTimeMatrix=[1031.40,1062.23];
eventTimes(1).hrTimeMatrix=[1701.57,1736.02;1795.63,1827.57;1875.22,1907.63;1953.44,1984.88;2053.20,2085.79];
SubjectParam(1).BP.ss=[113,85;115,95;110,90;110,90;115,90;117,90];
SubjectParam(1).BP.cp=[120,100];
SubjectParam(1).BP.ma=[115,100];
SubjectParam(1).BP.sb=[105,90];
SubjectParam(1).BP.hb=[110,100];
SubjectParam(1).BP.hr=[81,65;96,75;85,100;120,100;130,100];
SubjectParam(1).TotalPlot.BP=[0,200];
SubjectParam(1).TotalPlot.CO=[5,13];
SubjectParam(1).TotalPlot.SV=[50,150];
SubjectParam(1).TotalPlot.HR=[50,150];
SubjectParam(1).TotalPlot.TPR=[5,35];

eventTimes(2).ssTimeMatrix=[476.20,537.82;711.26,833.05;1136.69,1229.21;1477.53,1570.20;1668.95,1762.43;2553.67,2644.75];
eventTimes(2).cpTimeMatrix=[562.26,683.98];
eventTimes(2).maTimeMatrix=[844.19,1098.80];
eventTimes(2).sbTimeMatrix=[1282.24,1463.81];
eventTimes(2).hbTimeMatrix=[1599.65,1635.58];
eventTimes(2).hrTimeMatrix=[2037.61,2071.76;2187.91,2220.56;2289.18,2322.32;2354.68,2387.12;2494.64,2519.35];
SubjectParam(2).BP.ss=[110,90;100,82;100,82;100,90;102,91;105,88];
SubjectParam(2).BP.cp=[110,90];
SubjectParam(2).BP.ma=[105,92];
SubjectParam(2).BP.sb=[92,82];
SubjectParam(2).BP.hb=[110,95];
SubjectParam(2).BP.hr=[60,60;75,65;85,75;110,90;130,105];
SubjectParam(2).TotalPlot.BP=[20,160];
SubjectParam(2).TotalPlot.CO=[0,10];
SubjectParam(2).TotalPlot.SV=[10,100];
SubjectParam(2).TotalPlot.HR=[50,150];
SubjectParam(2).TotalPlot.TPR=[5,40];

eventTimes(3).ssTimeMatrix=[51.54,114.65;268.92,389.97;575.11,668.82;893.22,985.94;1060.55,1151.58;2004.56,2095.92];
eventTimes(3).cpTimeMatrix=[134.42,255.82];
eventTimes(3).maTimeMatrix=[407.00,561.86];
eventTimes(3).sbTimeMatrix=[700.65,883.36];
eventTimes(3).hbTimeMatrix=[1025.56,1046.84];
eventTimes(3).hrTimeMatrix=[1368.13,1401.36;1672.45,1704.43;1745.19,1777.79;1857.47,1889.87;1931.30,1963.31];
SubjectParam(3).BP.ss=[101,85;100,82;100,82;100,90;102,91;105,88];
SubjectParam(3).BP.cp=[105,90];
SubjectParam(3).BP.ma=[105,95];
SubjectParam(3).BP.sb=[92,82];
SubjectParam(3).BP.hb=[110,95];
SubjectParam(3).BP.hr=[60,60;75,72;85,85;100,90;110,105];
SubjectParam(3).TotalPlot.BP=[20,160];
SubjectParam(3).TotalPlot.CO=[0,10];
SubjectParam(3).TotalPlot.SV=[10,100];
SubjectParam(3).TotalPlot.HR=[50,150];
SubjectParam(3).TotalPlot.TPR=[5,40];

eventTimes(4).ssTimeMatrix=[321.79,386.83;544.39,667.20;898.17,990.23;1217.78,1309.54;1376.30,1467.55;1918.31,2010.44];
eventTimes(4).cpTimeMatrix=[405.47,525.47];
eventTimes(4).maTimeMatrix=[671.38,883.44];
eventTimes(4).sbTimeMatrix=[1013.25,1207.57];
eventTimes(4).hbTimeMatrix=[1328.60,1363.20];
eventTimes(4).hrTimeMatrix=[1531.99,1563.47;1628.79,1661.15;1703.63,1739.65;1800.22,1831.84;1860.55,1892.67];
SubjectParam(4).BP.ss=[120,85;100,87;100,87;100,90;102,91;105,88];
SubjectParam(4).BP.cp=[120,90];
SubjectParam(4).BP.ma=[150,110];
SubjectParam(4).BP.sb=[119,90];
SubjectParam(4).BP.hb=[110,102];
SubjectParam(4).BP.hr=[75,60;75,72;85,85;100,90;110,105];
SubjectParam(4).TotalPlot.BP=[20,220];
SubjectParam(4).TotalPlot.CO=[2,12];
SubjectParam(4).TotalPlot.SV=[30,140];
SubjectParam(4).TotalPlot.HR=[60,130];
SubjectParam(4).TotalPlot.TPR=[0,40];

eventTimes(5).ssTimeMatrix=[163.86,227.63;434.74,526.24;738.77,831.25;1057.90,1149.34;1274.46,1365.79;1843.19,1941.96];
eventTimes(5).cpTimeMatrix=[258.86,380.90];
eventTimes(5).maTimeMatrix=[548.83,725.72];
eventTimes(5).sbTimeMatrix=[863.85,1046.65];
eventTimes(5).hbTimeMatrix=[1205.46,1246.84];
eventTimes(5).hrTimeMatrix=[1424.16,1456.47;1483.43,1516.45;1554.08,1586.68;1621.88,1680.41;1780.29,1811.91];
SubjectParam(5).BP.ss=[121,91;122,90;120,87;100,90;120,91;115,88];
SubjectParam(5).BP.cp=[120,87];
SubjectParam(5).BP.ma=[120,98];
SubjectParam(5).BP.sb=[110,95];
SubjectParam(5).BP.hb=[130,91];
SubjectParam(5).BP.hr=[75,56;90,72;105,85;100,105;110,105];
SubjectParam(5).TotalPlot.BP=[20,220];
SubjectParam(5).TotalPlot.CO=[2,12];
SubjectParam(5).TotalPlot.SV=[30,140];
SubjectParam(5).TotalPlot.HR=[60,130];
SubjectParam(5).TotalPlot.TPR=[0,40];

eventTimes(6).ssTimeMatrix=[190.54,252.55;439.92,529.74;699.32,791.92;1008.61,1101.47;1191.72,1284.46;1748.70,1840.23];
eventTimes(6).cpTimeMatrix=[273.99,396.30];
eventTimes(6).maTimeMatrix=[544.08,684.54];
eventTimes(6).sbTimeMatrix=[812.21,995.29];
eventTimes(6).hbTimeMatrix=[1131.96,1181.73];
eventTimes(6).hrTimeMatrix=[1373.03,1405.04;1463.03,1496.09;1523.65,1558.18;1613.18,1645.38;1686.15,1719.64];
SubjectParam(6).BP.ss=[100,80;90,80;100,80;92,80;100,84;90,73];
SubjectParam(6).BP.cp=[120,87];
SubjectParam(6).BP.ma=[100,86];
SubjectParam(6).BP.sb=[85,85];
SubjectParam(6).BP.hb=[115,97];
SubjectParam(6).BP.hr=[53,50;72,62;80,75;82,78;100,87];
SubjectParam(6).TotalPlot.BP=[20,160];
SubjectParam(6).TotalPlot.CO=[0,12];
SubjectParam(6).TotalPlot.SV=[0,130];
SubjectParam(6).TotalPlot.HR=[40,130];
SubjectParam(6).TotalPlot.TPR=[0,45];

save ../Data\eventTimes eventTimes
save ../Data\SubjectParam SubjectParam