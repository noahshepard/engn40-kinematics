%% Load data
data = load('results_lo.txt');   % your file

t = data(:,1);
x = data(:,2) / 1000;   % mm -> m
y = data(:,3) / -1000; % adjust sign of y

n = length(t);

vx = zeros(n,1);
vy = zeros(n,1);
ay = zeros(n,1);

%% --- Velocity (central difference) ---
for i = 2:n-1
    dt = t(i+1) - t(i-1);
    vx(i) = (x(i+1) - x(i-1)) / dt;
    vy(i) = (y(i+1) - y(i-1)) / dt;
end

vx(1) = (x(2) - x(1)) / (t(2) - t(1));
vy(1) = (y(2) - y(1)) / (t(2) - t(1));

%% --- Acceleration (central difference on vy) ---
for i = 2:n-1
    dt = t(i+1) - t(i-1);
    ay(i) = (vy(i+1) - vy(i-1)) / dt;
end

%% --- Method's of caclulating acceleration ---
g = -9.81;
ay_g = ay / g;
a_avg = mean(ay);
a_avg_g = mean(ay_g);

fprintf('Average acceleration: %.3f m/s^2\n', a_avg);
fprintf('Average acceleration: %.3f g\n', a_avg_g);

p = polyfit(x, y, 2);   % quadratic fit

vx_avg = mean(vx);   % or however you computed vx
g_est = 2 * p(1) * vx_avg^2;

y_fit = polyval(p, x);    % fitted values at original data points

residuals = y - y_fit; 

delta_y = std(residuals);



fprintf('Estimated g: %.3f m/s^2\n', g_est);
fprintf('Estimated g: %.3f g\n', g_est / -9.81);

fprintf('Trendln: y = %.3f + %.3fx + %.3fx^2\n', p(3), p(2), p(1))
fprintf('Position Uncertainty (delta_y): %.4f m\n', delta_y);

%% --- Initial velocity + launch angle --- 
v0 = sqrt(vx(1)^2 + vy(1)^2);
theta = atan2(vy(1), vx(1));
theta_deg = rad2deg(theta);

fprintf('Initial velocity: %.3f m/s\n', v0);
fprintf('Launch angle: %.3f degrees\n', theta_deg);

%% --- Graphing ---

figure;

% Position Graphs
subplot(3,1,1)
scatter(t, x)
yticks(2:1:6)
ylabel('x (m)')
title('x vs Time')
grid on

subplot(3,1,2)
scatter(t, y)
yticks(-2:0.5:0)
ylabel('y (m)')
title('y vs Time')
grid on

figure;

% Velocity Graphs
subplot(3,1,1)
scatter(t, vx)
yticks(0:2:6)
ylabel('v_x (m/s)')
title('v_x vs Time')
grid on

subplot(3,1,2)
scatter(t, vy)
yticks(-4:2:4)
ylabel('v_y (m/s)')
title('v_y vs Time')
grid on

figure; 

% Acceleration Graph
subplot(3,1,1)
scatter(t, ay)
yline(-9.81, 'r--')
xlabel('Time (s)')
ylabel('a_y (m/s^2)')
title('a_y vs Time with expected g')
grid on

%% --- Trajectory Comparison ---
figure;
hold on;

scatter(x, y, 30, 'k', 'filled', 'DisplayName', 'Measured Data');

% Note: y_fit = p(1)x^2 + p(2)x + p(3)
plot(x, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Fit (g_{est} = %.2f)', g_est));

dx = x - x(1); % Distance from the start point
vx_stable = mean(vx); 
slope_start = 2*p(1)*x(1) + p(2);
y_std = y(1) + slope_start*dx + (g * dx.^2) / (2 * vx_stable^2);
plot(x, y_std, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Theory (g = -9.81)');

xlabel('Horizontal Distance x (m)');
ylabel('Vertical Distance y (m)');
title('Trajectory Comparison: Measured vs. Estimated vs. Theory');
legend('Location', 'best');
grid on;
axis equal; 
hold off;