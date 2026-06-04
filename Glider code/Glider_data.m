%% MANUAL VARIABLE ASSIGNMENT 
% Enter the parameters directly here for your simulations.
% Make sure you closed Excel before running the program

% -------------------------------------------------------------
% BLOCK 1: GLIDER VARIABLES
% -------------------------------------------------------------

dh = 1;             % Propeller diameter (m)
nh = 3100;          % Motor revolutions (rpm)
beta = 30;          % Blade pitch angle (degrees)
s = 17.95;          % Wing surface area (m^2)
m = 700;            % Total mass (kg)
CL = 1;             % Lift coefficient
CD = 0.015;         % Drag coefficient
V_mot = 400;        % Nominal motor voltage (V)
Vs = 80;            % Stall speed (km/h)
H_user = 1000;      % User target altitude (m)

% -------------------------------------------------------------
% BLOCK 2: BATTERY VARIABLES (CELL TYPES)
% -------------------------------------------------------------

% Cell type No. 1
diameter_cell1 = 18;    % cell diameter (mm)
heigh_cell1 = 65;       % cell height (mm)
weight_cell1 = 45.2;    % cell weight (g)
capacity_cell1 = 2;     % cell capacity (Ah)
voltage_cell1 = 3.7;    % cell voltage (V)
Imax_cell1 = 10;        % cell maximun current (A)
volume_cell1 = 3.1416 * (diameter_cell1)^2/4 * heigh_cell1/1000000;   % cell volume (dm³) autofill

% Cell type No. 2
diameter_cell2 = 18;    % cell diameter (mm)
heigh_cell2 = 65;       % cell height (mm)   
weight_cell2 = 45.8;    % cell weight (g)
capacity_cell2 = 2.5;   % cell capacity (Ah)
voltage_cell2 = 3.7;    % cell voltage (V)
Imax_cell2 = 7.5;       % cell maximun current (A)
volume_cell2 = 3.1416 * (diameter_cell2)^2/4 * heigh_cell2/1000000;   % cell volume (dm³) autofill

% Cell type No. 3
diameter_cell3 = 21;    % cell diameter (mm)
heigh_cell3 = 70;       % cell height (mm) 
weight_cell3 = 69.5;    % cell weight (g)
capacity_cell3 = 4.5;   % cell capacity (Ah)
voltage_cell3 = 3.7;    % cell voltage (V)
Imax_cell3 = 13.5;      % cell maximun current (A)
volume_cell3 = 3.1416 * (diameter_cell3)^2/4 * heigh_cell3/1000000;   % cell volume (dm³) autofill

% -------------------------------------------------------------
% BLOCK 3: ATMOSPHERIC AND PHYSICS CONDITIONS
% -------------------------------------------------------------

g = 9.81;   % Gravity (m/s^2)
rho = 1.2;  % Air density (kg/m^3)

% -------------------------------------------------------------
% BLOCK 4: CS-22 REGULATIONS
% -------------------------------------------------------------

RW_CS22 = 500;      % Maximum runway distance (m) 
H_CS22 = 360;       % Height target (m) 
t_CS22 = 4;         % Time to target (min)

%% PROPELLER COEFFICIENTS READING (POLYNOMIALS)
% This section  reads the Excel file to obtain coefficients a2, a1, a0...

document_data = 'Glider_parameters.xlsx';   % Find and read document
sheet_prop = 'Ct_Cp_J';                     % Find and read sheet

try
    % CT Coefficients (position inside excel)
    a2_Ct_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'C118:E118');
    a1_Ct_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'C119:E119');
    a0_Ct_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'C120:E120');
    
    a2 = polyval(a2_Ct_coeff, beta);
    a1 = polyval(a1_Ct_coeff, beta);
    a0 = polyval(a0_Ct_coeff, beta);

    % CP Coefficients (position inside excel)
    b2_Cp_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'I118:K118');
    b1_Cp_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'I119:K119');
    b0_Cp_coeff = readmatrix(document_data, 'Sheet', sheet_prop, 'Range', 'I120:K120');

    b2 = polyval(b2_Cp_coeff, beta);
    b1 = polyval(b1_Cp_coeff, beta);
    b0 = polyval(b0_Cp_coeff, beta);
    
    
catch
    warning('Could not read propeller coefficients from Excel. Please check the file and ranges.');
end