%% FIND CLIMB ANGLE

% Find climb rate for constant speed (force balance)
alpha = atand((f - CD * s * 0.5 * rho * (Vs * 1.3 / 3.6) ^ 2) / (m * g)); % returns degree value
climb_rate = (Vs * 1.3 / 3.6) * sind (alpha); % returns climb rate in m/s
%% TIME AND DISTANCE NEEDED TO REACH TARGET ACCORDING TO CS-22 

flight_dCS22 = H_CS22 / sind(alpha); % flight distance (m)
flight_tCS22 = (flight_dCS22 / (Vs * 1.3 / 3.6)) / 60 ; % flight time according to CS-22 target (min)

%% TIME AND DISTANCE NEEDED TO REACH TARGET ACCORDING TO USER CONDITIONS

flight_duser = H_user / sind (alpha); % flight distance (m)
flight_tuser = (flight_duser / (Vs * 1.3 / 3.6)) / 60; % flight time to target (min)



