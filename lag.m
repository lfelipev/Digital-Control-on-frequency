s = tf('s');
G = 1/((0.5*s+1)*(s+1));
error = 0.1;

% Steady state error for unit step input
% (1/(1+ka))
syms Ka
eq_Ka = 1/(1+Ka) == error;
Ka = solve(eq_Ka, Ka);

% Crossover frequency
syms wg
eq_wg = 180*pi/180 - atan(wg) - atan(0.5*wg) - 55*pi/180 == 0;
wg = solve(eq_wg, wg);
wg = double(wg);

% Value of K
% The gain crossover frequency of the modified system,
% magnitude at w should be 1
syms k
eq_k = k / ((sqrt(1+wg^2)) * sqrt((1+0.25*wg^2))) == 1;
K = solve(eq_k, k);
K = double(K);

% Constant a
a = Ka/K;
a = double(a);

% Place 1/t one decade below the gain crossover frequency
T = 10/wg;

numlead = a*K*[T 1]
denlead = [a*T 1]

C = tf(numlead, denlead);

figure(1)
H = G*C
bode(H)
grid on
%%
s = tf('s');
gc = 1/((s+1)*(0.5*s+1));
Gz = c2d(gc, 0.1, 'zoh');

aug = [0.1 1];
gwss = bilin(ss(gz), -1, 'S_Tust', aug);
Gw = tf(gwss)

error = 0.1;
Ka = 9;

% Crossover frequency
syms wg
eq_wg = 180*pi/180 - atan(wg) - atan(0.5*wg) - atan(0.05*wg) + atan(0.0025*wg) - 55*pi/180 == 0;
wg = solve(eq_wg, wg);
wg = double(wg);
wg = wg(2);

% K
% The magnitude at wg should be 1.
syms K
eq_K = (0.00025 * K * sqrt(400+wg^2) * sqrt(160000 + wg^2)) / (sqrt(1 + wg^2) * sqrt(4 + wg^2)) == 1;
K = solve(eq_K, K);
K = double(K);

% Constant a
a = Ka/K;

% Place 1/t onde decade below the crossover frequency
tau = 10/wg;

% The controller in w-plane is
w = tf('s');
C = K*a*(1+tau*w)/(1+a*tau*w);

z = tf('z', 0.1);
Cz = 9 * (83*z - 81) / (179*z - 177)
figure(1)
bode(Gz)

figure(2)
bode(Cz * Gz)