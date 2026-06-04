%% FIGURE: DISTANCE - VELOCITY - GROUND FRICTION %%

figure;
yyaxis left
plot(record_xx, record_vvpx);
xlim ([0, max(record_xx)]);
ylim([0, max(record_vvpx)]);
xlabel ('Distance (m)')
ylabel('Velocity (m/s)')

yyaxis right
plot (record_xx,record_fr);
xlim([0, max(record_xx)]);
ylim([0,max(record_fr)]);
ylabel('Reaction force (N)')
grid on

%% FIGURE: DISTANCE - POWER TIME %%

figure;
yyaxis left
plot(record_xx, record_p);
xlim ([0, max(record_xx)]);
ylim([0, max(record_p)+5000]);
xlabel ('Distance (m)')
ylabel('Power (W)')

yyaxis right
plot (record_xx,record_t);
xlim([0, max(record_xx)]);
ylim([0,closest_time_friction_zero]);
ylabel('Time (s)')
grid on


%% FIGURE: POWER - TIME GRAPHIC %% 

limit_A = 0; % first limit from stationary state
limit_B = closest_time_friction_zero; % time in seconds until take off
limit_AB = (record_t >= limit_A) & (record_t <= limit_B); % to make an accurate plot limits
t_limited = record_t(limit_AB); % to display graphics until limit
p_limited = record_p(limit_AB); % to display graphics until limit
E_takeoff = trapz (t_limited,p_limited); % energy used for take off (Joules)

figure; 
plot(t_limited, p_limited, 'LineWidth', 2);
title(sprintf('Power-Time (Energy required: %.2f J)', E_takeoff));
xlabel('Time (s)');
ylabel('Power (W)');
grid on;

