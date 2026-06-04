%% RUNGE-KUTTA METHOD %%

% to solve the differential equation we will make use of Ruge-Kutta
% that is because the problem is a second order differential equation

record_xx = [];     % position vector declaration
record_vvpx = [];   % velocity vector declaration
record_fr = [];     % reaction force (ground) vector declaration
record_p = [];      % power vector declaration
record_t = [];      % time vector declaration
record_work = [];   % work vector declaration
record_torque = []; % torque vector declaration


% Initial conditions
h = 0.01;           % small increment
t = 0;              % time set to zero
xx = 0;             % distance set to zero
vvpx= 0;            % initial velocity set to zero
n = 0;              % iteration controller for "while" loop set to zero
work = 0;           % work set to zero
fr = 9.8 * m;       % ground friction force set to initial conditions 
vpx = 0;            % small increment of actual velocity set to zero

% Matlab will calculate until we take off or we get the imposed velocity or
% we get the runway distance available
while ((xx <= RW_CS22 && fr >= 0) || (xx <= RW_CS22 && vpx <= Vs * 1.3 / 3.6))

%%% Calculation Nº1 %%%
[accx, ~] = acceleration(vvpx, nh, dh, CD, s, m, rho, a2, a1, a0); % see acceleration function below
ax = 0.5 * h * accx;

%%% Calculation Nº2 %%%
[accx, ~] = acceleration(vvpx+ax, nh, dh, CD, s, m, rho, a2, a1, a0); % see acceleration function below
bx = 0.5 * h * accx;

%%% Calculation Nº3 %%%
[accx, ~] = acceleration(vvpx+bx, nh, dh, CD, s, m, rho, a2, a1, a0); % see acceleration function below
cx = 0.5 * h * accx;

%%% Calculation Nº4 %%%
[accx, ~] = acceleration(vvpx+2*cx, nh, dh, CD, s, m, rho, a2, a1, a0); % see acceleration function below
dx = 0.5 * h * accx;

% Instanteous distance traveled for the glider
kx = (ax + bx + cx) / 3; 
xx = xx + h * (vvpx + kx);
% Instanteous velocity of the glider
k1x = (ax + 2 * bx + 2 * cx + dx) / 3; 
vvpx = vvpx + k1x;

% Next step to evaluate
t = t + h;
n = n + 1;

    if n == 20 % every 20 calculations we save one point for each parameter
    
    fr = m * g - CL * s * 0.5 * rho * vvpx ^ 2;  % Y axis force balance while on ground 
    j = vvpx / (nh / 60) / dh; % j is also called advance ratio
    cp = b2 * j^2 + b1 * j + b0; % polynomical equation from propeller in excel
    p = cp * rho * (nh / 60) ^ 3 * dh ^ 5; % formula associated with J-cp graphic (power)
    work = work + p * n * h; % work calculation (Joule)
    T = p / (nh / 60 * 2 * pi); % torque calculation

    % save values inside vectors
    record_xx = [record_xx, xx];
    record_vvpx = [record_vvpx, vvpx];
    record_fr = [record_fr, fr];
    record_p = [record_p, p];
    record_t = [record_t, t];
    record_work = [record_work, work];
    record_torque = [record_torque,T];

    
    n=0; % when all values are saved, the "n" counter is set to zero
    end 
end   
%% READ AND STORE FORCE VALUE (f) 
[~,f] = acceleration(vpx, nh, dh, CD, s, m, rho, a2, a1, a0); % "~"allow to show force as a variable
%% ACCELERATION FUNCTION %%
function [acc,f] = acceleration(vpx, nh, dh, CD, s, m, rho, a2, a1, a0)

j = vpx / (nh / 60) / dh; % j is also called advance ratio
ct = a2 * j^2 + a1 * j + a0; % polynomical equation from propeller in excel
f = ct * rho * (nh / 60) ^ 2 * dh ^ 4; % formula associated with J-ct graphic (force)
acc = (f - CD * s * 0.5 * rho * vpx ^ 2) / m; % acceleration equation defined; X axis force balance while on ground 

end
%% SAVE TIME AND DISTANCE VALUES FOR FRICTION FORCE <= 0 FOR GRAPHICS %%

% Initialize empty variables to store the closest values
closest_distance_friction_zero = NaN;
closest_time_friction_zero = NaN;

% Find the indices where friction is less than zero or equal to zero
non_positive_friction_indices = find(record_fr <= 0);

if ~isempty(non_positive_friction_indices)
    % Extract the friction values at those times
    non_positive_frictions = record_fr(non_positive_friction_indices);

    % Find the index of the friction value closest to zero (the largest value,
    % i.e., least negative or zero) within this subset
    [closest_friction_value, closest_local_index] = max(non_positive_frictions);

    % Get the original index in the main vectors
    closest_global_index = non_positive_friction_indices(closest_local_index);

    % Store the corresponding distance and time values
    if closest_global_index >= 1 && closest_global_index <= length(record_xx)
        closest_distance_friction_zero = record_xx(closest_global_index);
    end
    if closest_global_index >= 1 && closest_global_index <= length(record_t)
        closest_time_friction_zero = record_t(closest_global_index);
    end
end

