% 435MHz Yagi-Uda Antenna Simulation

%% Parameters
freq = 435e6;
c = 3e8;
lambda = c/freq*0.943;
spacing = c/freq;
%% Aluminum boom 
boom_d_round = 0.6* 19.05/1000; % meters
%rods will be placed ontop on the boom via plastic instulation 
%use a 35% factor of boom form the center
correction = boom_d_round *0.35; 


%% Driven Element
myDrivenElement = dipole(Length=0.5*lambda, Width=0.00635, Tilt = 90, ... % Driven element length
    TiltAxis =[0,1,0]);

%% Yagi array definition
yagiAntenna = yagiUda(...
    Exciter=myDrivenElement, ...
    NumDirectors=3, ...
    ReflectorLength=0.482*lambda, ... % Reflector Length
    ReflectorSpacing=0.2*spacing, ...
    DirectorLength=([0.428, 0.424, 0.428]*lambda), ... % Director Lengths
    DirectorSpacing=[0.2, 0.2, 0.2]*spacing);

%% Element Dimensions
to_inches = 39.37;
fprintf('\n=== 435MHz Yagi-Uda Element Dimensions ===\n');
fprintf('\nElement lengths:\n');
fprintf('Reflector          : %.4f in\n', 0.482*(lambda+correction)*to_inches);
fprintf('Driven             : %.4f in\n', 0.500*(lambda+correction)*to_inches);
fprintf('Director 1         : %.4f in\n', 0.428*(lambda+correction)*to_inches);
fprintf('Director 2         : %.4f in\n', 0.424*(lambda+correction)*to_inches);
fprintf('Director 3         : %.4f in\n', 0.428*(lambda+correction)*to_inches);
fprintf('\nSpacings:\n');
fprintf('Reflector spacing  : %.4f in\n', 0.2*spacing*to_inches);
fprintf('Director spacing   : %.4f in\n', 0.2*lambda*to_inches);
fprintf('Total boom length  : %.4f in\n', 0.8*lambda*to_inches);

%% Figure 1 — Antenna geometry
figure(1);
show(yagiAntenna); 
title("435MHz Yagi Antenna Geomtry"); 

% Figure 2 — 3D radiation pattern
figure(2);
pattern(yagiAntenna,freq);
title("3D Radiation Pattern");

% Figure 3 — Azimuth radiation pattern (left/right)
figure(3);
patternAzimuth(yagiAntenna,freq);
title("Azimuth Radiation Pattern");

% Figure 4 — Elevation radiation pattern 
figure(4);
patternElevation(yagiAntenna,freq);
title("Elevation Radiation Pattern");

% Figure 5 — S[1,1] return loss
freq_range= linspace(400e6,500e6,101);
figure(5);
s = sparameters(yagiAntenna,freq_range);
rfplot(s);
title("S[1,1] Return Loss");
xlabel("Frequency (Hz)");
ylabel("S[1,1] dB");

% Figure 6 — VSWR
figure(6);
vswr(yagiAntenna,freq_range,50);
title("VSWR");
yline(2, 'r--', 'VSWR = 2');

% Figure 7 — Input impedance
figure(7);
impedance(yagiAntenna,freq_range);
title("Input Impedance");

% Figure 8 — Smith chart
figure(8);
smithplot(s);
title('Smith Chart S[1,1]');


