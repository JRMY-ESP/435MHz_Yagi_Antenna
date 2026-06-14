% 435MHz Yagi-Uda Antenna Simulation
% Assumed for element diameter = 0.0085*lambda
%% Paramters 
f = 435e6;
c = 3e8;
lambda = c / f; 
diameter = 0.00635; % diamter of the rods [mm]


%% correction for diamter = 0.00635
delta = (diameter/lambda) - 0.0085;
correction_factor = delta * (-8.57);


%% Driven Element
myDrivenElement = dipole(Length=(0.466+correction_factor)*lambda, Width=0.00635, Tilt = 90,TiltAxis =[0,1,0]);

%% Yagi array elements
spacing = lambda;
yagiAntenna = yagiUda(...
    Exciter=myDrivenElement, ...
    NumDirectors=3, ...
    ReflectorLength=(0.482+correction_factor)*lambda, ... % Reflector Length
    ReflectorSpacing=0.2*spacing, ...
    DirectorLength=(([0.428+correction_factor, 0.424+correction_factor, 0.428+correction_factor])*lambda), ... % Director Lengths
    DirectorSpacing=[0.2, 0.2, 0.2]*spacing);



%% Graphs 

% 3D radiation pattern
figure(1);
pattern(yagiAntenna,f);
title("3D Radiation Pattern");

% Azimuth radiation pattern (left/right)
figure(2);
patternAzimuth(yagiAntenna,f);
title("Azimuth Radiation Pattern");

% Elevation radiation pattern 
figure(3);
patternElevation(yagiAntenna,f);
title("Elevation Radiation Pattern");

% return loss s[1,1]
freq_range= linspace(400e6,500e6,101);
figure(4);
s = sparameters(yagiAntenna,freq_range);
rfplot(s);
title("S[1,1] Return Loss");
xlabel("Frequency (Hz)");
ylabel("S[1,1] dB");

% VSWR
figure(5);
vswr(yagiAntenna,freq_range,50);
title("VSWR");
yline(2, 'r--', 'VSWR = 2');


% Input impedance
figure(6);
impedance(yagiAntenna,freq_range);
title("Input Impedance");

% Smith chart
figure(7);
smithplot(s)
title('Smith Chart S[1,1]');


%% Element Lengths

fprintf('Reflector:      %.2f in\n', L_reflector*39.3701);
fprintf('Driven Element: %.2f in\n', L_driven*39.3701);
fprintf('Director 1:     %.2f in\n', L_dir1*39.3701);
fprintf('Director 2:     %.2f in\n', L_dir2*39.3701);
fprintf('Director 3:     %.2f in\n', L_dir3*39.3701);
fprintf('Boom Length:    %.2f in\n',0.2*lambda*39.3701);
