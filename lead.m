clc
clear all
s = tf('s');
G = 1/(s*(s+1));

K = 10;
error = 0.1;
PM = 45;

% Center frequency
syms wg
eq_wg = 10/(wg*sqrt(1+wg^2)) == 1;
wg = solve(eq_wg, wg);
wg = double(wg(1));

% Phase at wg
PM_wg = (-90*pi/180 - atan(wg))*180/pi;
PM_wg = 180 + PM_wg;
PM = PM - PM_wg;

% Phi max
phi = PM + 10;
phi = phi*pi/180;

% Constant a
a = (1 - sin(phi))/(1 + sin(phi));

% w_max 
w = 4.41;

% tau
tau = 1/(w*(sqrt(a)));

numlead = K*[tau 1];
denlead = [a*tau 1];

C = tf(numlead, denlead);

figure(1)
H = G*C
margin(H)
grid on

%%
clc
clear all

% The given system at T = 0.2 sec is
z = tf('z', 0.2);
Gz = (0.0187*z + 0.0175) / (z^2 - 1.8187*z + 0.8187);

PM = 50;

% Applying the bilinear transform
aug = [0.2 1];
gwss = bilin(ss(Gz), -1, 'S_Tust', aug);
Gw = tf(gwss);

%Value of Kv
K = 2;

% Get the wg and PM_wg by the graphic to compute phi
figure(1)
margin(K*Gw)
wg = 1.26;
PM_wg = 31.6;

safety = 11.6;
phi = PM - 31.6 + safety;
phi = phi*pi/180;

% Constant a
a = (1 - sin(phi))/(1 + sin(phi));

% Center frequency w_max
w = K/(sqrt(a)*2);

% T and aT
T = 1/(w*sqrt(a));

numlead = K*[T 1];
denlead = [a*T 1];

C = tf(numlead, denlead);

figure(2)
H = Gw*C
margin(H)
grid on

% Back to z-plan
z = tf('z', 0.1);
Gz = 2*(2.55*z - 2.08)/(z - 0.53)