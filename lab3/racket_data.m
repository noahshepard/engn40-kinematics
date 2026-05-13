data = load('results_collision_pickleball_hard_speed.txt');

t = data(:,1); 
rack_x = data(:,2); 
rack_y = data(:,3); 
ball_x = data(:,4); 
ball_y = data(:,5); 

n = length(t); 

rack_vx = zeros(n,1);
rack_vy = zeros(n,1);

ball_vx = zeros(n,1);
ball_vy = zeros(n,1);

%% --- Manually Calculated Data ---
% Enter per video

step_size = 2; 
t_contact_start = 0.008; 
i_contact_start = t_contact_start * (1000/step_size); %% get index (multiply by fps/steps)

t_contact_end = 0.012; 
i_contact_end = t_contact_end * (1000/step_size);

h_before = 0.268; 
h_after = 0.106; 

cor = sqrt(h_after/h_before); 

fprintf('COR: %.3f\n', cor);

mass_rack = 211 / 1000;
mass_ball = 26 / 1000; 


%% --- Velocity (central difference) ---
for i = 2:n-1
    dt = t(i+1) - t(i-1);
    rack_vx(i) = (rack_x(i+1) - rack_x(i-1)) / dt;
    rack_vy(i) = (rack_y(i+1) - rack_y(i-1)) / dt;

    ball_vx(i) = (ball_x(i+1) - ball_x(i-1)) / dt;
    ball_vy(i) = (ball_y(i+1) - ball_y(i-1)) / dt;
end

rack_vx(1) = (rack_x(2) - rack_x(1)) / (t(2) - t(1));
rack_vy(1) = (rack_y(2) - rack_y(1)) / (t(2) - t(1));

ball_vx(1) = (ball_x(2) - ball_x(1)) / (t(2) - t(1));
ball_vy(1) = (ball_y(2) - ball_y(1)) / (t(2) - t(1));

%% --- Plotting (position, velocity) --- 

figure; 
hold on; 
scatter(t, ball_x); 
scatter(t, rack_x); 
ylabel('X position (mm)'); 
xlabel('Time (s)'); 
title('X position vs. time for Pickleball Hard')
xline(t_contact_start, '--');
xline(t_contact_end, '-.')

legend('Ball', 'Racket', 'Contact Point');


hold off; 

figure; 
hold on; 
scatter(t, ball_vx); 
scatter(t, rack_vy); 
ylabel('X velocity (mm/s)'); 
xlabel('Time (s)'); 
title('X velocity vs. time for Pickleball Hard')
xline(t_contact_start, '--');
xline(t_contact_end, '-.')
legend('Ball', 'Racket', 'Contact Start', 'Contact End');

%% --- Expected Velocity Analysis --- 


ball_v_before = mean(ball_vx(1:i_contact_start-1)) / 1000;
ball_v_after = mean(ball_vx(i_contact_end+1:end)) / 1000;

rack_v_before = mean(rack_vx(1:i_contact_start-1)) / 1000;
rack_v_after = mean(rack_vx(i_contact_end:end)) / 1000;


exp_ball_v = mass_rack * (1 / (mass_rack + mass_ball)) * (1 + cor) * rack_v_before; 

fprintf('Recorded average velocity of the ball post collision: %.3f m/s\n', ball_v_after); 
fprintf('Expected velocity of the ball post collision: %.3f m/s\n', exp_ball_v); 

%% --- Average Force Analysis --- 

delta_t = t_contact_end - t_contact_start; 

f_avg = (mass_ball * (ball_v_after))/delta_t; 
f_avg_w = f_avg / (mass_rack * 9.81); 

fprintf('Average force on the ball during the collision %.3f N\n', f_avg);
fprintf('Average force in terms of racket weight %.3f\n', f_avg_w); 

%% --- Mass and Velocity Ratio Analysis --- 

v_b_to_u_r = ball_v_after / rack_v_before; 
m_r_to_m_b = mass_rack / mass_ball; 

fprintf('Ratio of V_fb to V_ir is: %.3f\n', v_b_to_u_r); 
fprintf('Ratio of m_r to m_b is: %.3f\n', m_r_to_m_b); 










