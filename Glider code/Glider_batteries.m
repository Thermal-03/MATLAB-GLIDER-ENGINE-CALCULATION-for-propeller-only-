%% MAIN PARAMETERS %%

Energy_Wh_takeoff = E_takeoff / 3600; % from Power (W) - Time (s) graphic
max_power = max(record_p); % to find maximun power delivered for the motor
Imax_mot = max_power / V_mot; % maximun intensity used for the motor

Energy_Wh_cell1 = capacity_cell1 * voltage_cell1; % cell capacity in Wh
Energy_Wh_cell2 = capacity_cell2 * voltage_cell2; % cell capacity in Wh
Energy_Wh_cell3 = capacity_cell3 * voltage_cell3; % cell capacity in Wh

%% IN FLIGHT CALCULATIONS (AFTER TAKE-OFF)
% Run flight calculations script
run ('in_flight_to_target.m'); % runs the script

% Total energy  during flight (Wh) when distance and velocity match the requeriments
Energy_Wh_flight = f * flight_duser / 3600;

% Total energy required takeoff + flight
Energy_Wh_total = Energy_Wh_flight + Energy_Wh_takeoff;
% Total energy required for takeoff is already calculated above

%% CELLS DISPOSITIONS %%

% Series cells and round up the number
S_cell1 = ceil(V_mot / voltage_cell1);
S_cell2 = ceil(V_mot / voltage_cell2);
S_cell3 = ceil(V_mot / voltage_cell3);

% Parallel cells considering both intensity and energy constrains (maximum value)
P_cell1 = max(ceil(Imax_mot / Imax_cell1), ceil (Energy_Wh_total / (S_cell1 * Energy_Wh_cell1)));
P_cell2 = max(ceil(Imax_mot / Imax_cell2), ceil (Energy_Wh_total / (S_cell2 * Energy_Wh_cell2)));
P_cell3 = max(ceil(Imax_mot / Imax_cell3), ceil (Energy_Wh_total / (S_cell3 * Energy_Wh_cell3)));

% Calculate volume of cylinder battery pack
volume_cell1_cy = S_cell1 * P_cell1 * volume_cell1; % volume in dm^3 = Liters
volume_cell2_cy = S_cell2 * P_cell2 * volume_cell2; % volume in dm^3 = Liters
volume_cell3_cy = S_cell3 * P_cell3 * volume_cell3; % volume in dm^3 = Liters

% Calculation from Cylinder volume (cy) to Box volume (bx) <<apply factor 4/pi>>
volume_cell1_bx = 4/pi * volume_cell1_cy; % factor come from dividing cy and bx volume
volume_cell2_bx = 4/pi * volume_cell2_cy; % factor come from dividing cy and bx volume
volume_cell3_bx = 4/pi * volume_cell3_cy; % factor come from dividing cy and bx volume

% Calculate total battery weight
weight_cell1_total = S_cell1 * P_cell1 * weight_cell1 / 1000; % weight in Kilogram
weight_cell2_total = S_cell2 * P_cell2 * weight_cell2 / 1000; % weight in Kilogram
weight_cell3_total = S_cell3 * P_cell3 * weight_cell3 / 1000; % weight in Kilogram

%% FLIGHT TIME DELIVERED FOR CELLS %%

% Avarage flight time considering motor and cells distribution
av_pwr = mean(record_p); % avarage power using power vector
flight_t_cell1 = ((S_cell1 * P_cell1 * Energy_Wh_cell1) / av_pwr) * 60; % time in minutes
flight_t_cell2 = ((S_cell2 * P_cell2 * Energy_Wh_cell2) / av_pwr) * 60; % time in minutes
flight_t_cell3 = ((S_cell3 * P_cell3 * Energy_Wh_cell3) / av_pwr) * 60; % time in minutes 