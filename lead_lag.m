clc
clear

s = tf('s');
G = 1/(s*(1+0.1*s)*(1+0.2*s));
PM = 45;
w = 10;
Kv = 30;

figure(1)
margin(Kv*G)

% From figure 1 the angle phase is -198 at w = 10 rad/s
phi = PM - (180 - 198);
safety = 2;
phi = phi + safety;
phi = phi*pi/180;

% Constant alpha_2
a_2 = (1 - sin(phi))/(1 + sin(phi));

% Tau
tau_2 = 1/(10*sqrt(a_2));

% The lead compensator
C_1 = Kv * (1 + tau_2 * s) / (1 + a_2 * tau_2 * s)

figure(2)
margin(C_1 * G)

% By the graphic at 10 rad/sec the phase angle is -134
% the gain is 12.4dB
% alpha_1
syms a_1
eq_a_1 = 20 * log10(a_1) == 12.6;
a_1 = solve(eq_a_1, a_1);
a_1 = double(a_1);

% 1/tau_1 = 0.25 to retain the desired PM
tau_1 = 4;

% The lag compensator
C_2 = (1 + tau_1 * s) / (1 + a_1 * tau_1 * s);

% The compensated system
H = G * C_1 * C_2;
figure(3)
margin(H)

%%
clc
clear

s = tf('s');
G = 1/(s*(1+0.1*s)*(1+0.2*s));
Gz = c2d(G, 0.1, 'zoh');

aug = [0.1 1];
Gwss = bilin(ss(Gz), -1, 'S_Tust', aug);
Gw = tf(Gwss)

K = 30;
figure(1)
margin(K * Gw)

% phi
safety = 5;
phi = 20 - (180 - 221) + safety;
phi = phi*pi/180;

% alpha_2
a_2 = (1 - sin(phi))/(1 + sin(phi));

% tau_2
tau_2 = 1/(10 * sqrt(a_2));

% The lead compensator
C_1 = K * (1 + tau_2 * s) / (1 + a_2 * tau_2 * s)

figure(2)
margin(C_1 * Gw)

% At 10 rad/sec, the magnitude is 14.2dB
syms a_1
eq_a_1 = 20*log10(a_1) == 14.2;
a_1 = solve(eq_a_1, a_1);
a_1 = double(a_1);

% tau_1
tau_1 = 1;

% The lag compensator
C_2 = (1 + tau_1 * s) / (1 + a_1 * tau_1 * s);

% Controller
C = C_1 * C_2;

% The compensated system
H = Gw * C
figure(3)
margin(H)