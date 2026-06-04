% this script organizes all results in a table and shows any potential
% issue at the end of the table as a numbers

%% 1. EXTRA DATA NEEDED TO SHOWCASE 
max_torque = max(record_torque); % rated torque 

%% 2. EXPORTATION CONFIGURATION (LOCATION)
document_data = 'Glider_parameters.xlsx';
sheet_name = 'Results';
MAX_TESTS_VISIBLE = 10; % maximum tests visible in excel
SCRIPT_COUNTER = 'script_counter.mat';

% Counter persistent logic that remembers the last execution time so it 
% can resume from the point you left off
test_number = 1; % default number for counter
try
    load(SCRIPT_COUNTER, 'test_number');
catch
    test_number = 1;
end

%% 3. CALCULATE THE CYCLIC POSITION AND STARTING ROW
current_test_num = mod(test_number - 1, MAX_TESTS_VISIBLE) + 1;
% initial row: Data starts at Row 3 
initial_row = current_test_num + 2; 
initial_cell = ['A', num2str(initial_row)];

%% 4. DEFINITION OF HEADINGS (Row 2)
header_data = {
    'Pitch blade angle (º)', ...
    'Prop diameter (m)', ...
    'Motor velocity (rpm)', ...
    'Rated power (W)', ...
    'Rated torque (N·m)', ...
    'Time to target (min)', ...
    'Climb rate (m/s)', ...
    'Total energy (Wh)', ...
    'Takeoff energy (Wh)', ...
    'Flight energy(Wh)', ...
    'Flight time1 (min)',...
    'S1', ...
    'P1', ...
    'Weight1 (Kg)', ...
    'Volume1 (L)', ...
    'Flight time2 (min)',...
    'S2', ...
    'P2', ...
    'Weight2 (Kg)', ...
    'Volume2 (L)', ...
    'Flight time3 (min)',...
    'S3', ...
    'P3', ...
    'Weight3 (Kg)', ...
    'Volume3 (L)', ...
    'ID', ...
};

%% 5. ROW VALUES CREATION

value_row = {
beta, ...               % prop pitch angle   
dh, ...                 % prop diameter
nh, ...                 % rpm motor
max_power, ...          % rated motor power
max_torque, ...         % rated torque (ja és escalar)
flight_tuser, ...       % time to height defined for user
climb_rate, ...         % climb rate
Energy_Wh_total, ...    % total energy required
Energy_Wh_takeoff, ...  % total energy needed for takeoff
Energy_Wh_flight, ...   % total energy needed during flight 
flight_t_cell1, ...     % total flight time for cell 1
S_cell1, ...            % cells 1 in series
P_cell1, ...            % cells 1 in parallel
weight_cell1_total, ... % battery weight cell 1
volume_cell1_bx, ...    % battery volume cell 1
flight_t_cell2, ...     % total flight time for cell 2
S_cell2, ...            % cells 2 in series
P_cell2, ...            % cells 2 in parallel
weight_cell2_total, ... % battery weight cell 2
volume_cell2_bx, ...    % battery volume cell 2
flight_t_cell3, ...     % total flight time for cell 3
S_cell3, ...            % cells 3 in series
P_cell3, ...            % cells 3 in parallel
weight_cell3_total, ... % battery weight cell 3
volume_cell3_bx, ...    % battery volume cell 3
''                       
};

%% 6. PROGRAM VALIDATION AND ALERT ID GENERATION
% Lits to save the ID alerts
alert_ids = [];

%%%% ----------- NUMERIC ALERTS (1, 2, 3, 4) ----------- %%%%

% ID 1: Flight time exceeds CS-22 regulation for specified altitude
if flight_tCS22 > t_CS22
    alert_ids(end+1) = 1;
    fprintf(' Flight time exceeds CS-22 regulation for specified altitude \n')
end

% ID 2: Glider can't take of in X meters
if (xx >= RW_CS22 && fr >= 0) 
    alert_ids(end+1) = 2;
   fprintf(' Glider can not take-off in specified meters \n') 
end

% ID 3: Glider can't reach the speed for X runway safe distance
if (xx >= RW_CS22 && max(record_vvpx) <= (Vs * 1.3 / 3.6))
    alert_ids(end+1) = 3;
    fprintf(' Glider can not reach the safe speed for the maximum mandatory distance \n')
end

% ID 4: Propeller breakage alert
if (nh >= 4000 / dh)
    alert_ids(end+1) = 4;
     fprintf(' Propeller breakage alert \n')
end

%%%% --------------- ASSIGN AND CONVERT TO TEXT  --------------- %%%%

% ID -: There are no problems
if isempty(alert_ids)
    alert_string = '-'; % "-" stands for 'OK! All regulatory and operational requirements are ok'
    fprintf(' No problems found \n')
else
    % Convert numeric vector (e.x. [1 4]) to comma-separated string ('1,4')
    alert_string = strrep(num2str(alert_ids), ' ', ','); 
end

% We assign the alert string to the last position of the data row 
value_row{end} = alert_string;

%% 7. FINAL EXPORTATION
try
    % STEP A: WRITE THE HEADINGS 
    writecell(header_data, document_data, 'Sheet', sheet_name, 'Range', 'A2');
    
    % STEP B: WRITE DATA ROWS
    % Write all date in cells (numbers)
    writecell(value_row, document_data, 'Sheet', sheet_name, 'Range', initial_cell);
    
    % 8. INCREASE AND SAVE THE COUNTER FOR THE NEXT RUN
    test_number = test_number + 1;
    save(SCRIPT_COUNTER, 'test_number');
    
catch ME
    warning(ME.identifier, 'Exportation failed. Make sure you closed the excel before running. Message: %s', ME.message);
end