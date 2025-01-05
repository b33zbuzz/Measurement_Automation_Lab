% Closing all windows and clearing variables for ease of use
close all;
clear all;

% Reading and storing the data from the files
f = dlmread('BAL_46_7.ASC',';','A15..A2015');

bal_O = dlmread('BAL_46_7.ASC',';','B15..B2015') + ...
     1i*dlmread('BAL_46_7.ASC',';','C15..C2015');

bal_S = dlmread('BAL_O.ASC',';','B15..B2015') + ...
     1i*dlmread('BAL_O.ASC',';','C15..C2015');

bal_T = dlmread('BAL_S.ASC',';','B15..B2015') + ...
     1i*dlmread('BAL_S.ASC',';','C15..C2015');

cab_S = dlmread('CABLE_S.ASC',';','B15..B2015') + ...
     1i*dlmread('CABLE_S.ASC',';','C15..C2015');

cab_O = dlmread('CABLE_O.ASC',';','B15..B2015') + ...
     1i*dlmread('CABLE_O.ASC',';','C15..C2015');

% Computing BALUN impedances for 47 ohm termination
ZBO = 47*(1+bal_O)./(1-bal_O);
ZBS = 47*(1+bal_S)./(1-bal_S);
ZBT = 47*(1+bal_T)./(1-bal_T);

% Computing ABCD parameters
A = ZBO.*sqrt((ZBS-ZBT)./(47*(ZBT-ZBO).*(ZBO-ZBS)));
B = ZBS.*sqrt(47*(ZBT-ZBO)./((ZBS-ZBT).*(ZBO-ZBS)));
C = sqrt((ZBS-ZBT)./(47*(ZBT-ZBO).*(ZBO-ZBS)));
D = sqrt(47*(ZBT-ZBO)./((ZBS-ZBT).*(ZBO-ZBS)));

% Computing CABLE impedances
Z1CO = 47*(1+cab_O)./(1-cab_O);
Z1CS = 47*(1+cab_S)./(1-cab_S);
Z2CO = (B-D.*Z1CO)./(C.*Z1CO-A);
Z2CS = (B-(D.*Z1CS))./((C.*Z1CS)-A);

% Computing characteristic impedance and propagation constant
ZW = sqrt(Z2CS.*Z2CO);
gamma = atanh(sqrt(Z2CS./Z2CO));
ReG = real(gamma);
ImG = imag(gamma);

% Plotting
figure(1);
plot(f,abs(ZW));
title('Amplitude of Characteristic Impedance');
xlabel('Frequency [Hz]');
ylabel('Magnitude of ZW)');

figure(2);
plot(f,angle(ZW)*(180/pi));
title('Phase of Characteristic Impedance');
xlabel('Frequency [Hz]');
ylabel('Phase of ZW');

figure(3);
ReGnp = ReG*(20/log(10));
plot(f,ReGnp);
title('Attenuation');
xlabel('Frequency [Hz]');
ylabel('Re(Gamma)');

figure(4);
plot(f,ImG);
title('Phase Constant');
xlabel('Frequency [Hz]');
ylabel('Im(Gamma) [rad/m]');
