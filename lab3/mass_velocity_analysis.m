x = [8.115 8.115 4.875 4.875 57.333 57.333];
y = [0.731 0.825 0.560 0.850 0.957 1.105];

figure;
hold on;
grid on;

scatter(x, y, 80, 'filled');

% Medium Trials
x_odd = x([1 3 5]);
y_odd = y([1 3 5]);

% Hard Trials
x_even = x([2 4 6]);
y_even = y([2 4 6]);

p_odd = polyfit(x_odd, y_odd, 1);
p_even = polyfit(x_even, y_even, 1);

xfit = linspace(min(x), max(x), 100);
yfit_odd = polyval(p_odd, xfit);
yfit_even = polyval(p_even, xfit);

plot(xfit, yfit_odd, 'r-', 'LineWidth', 2);
plot(xfit, yfit_even, 'b-', 'LineWidth', 2);

xlabel('Ratio of racket mass to ball mass');
ylabel('Ratio of ball velocity to intial racket velocity');
title('Dimensionless ball velocity vs. ball/racket mass ratio for all trials');

legend('velocity vs. mass', 'Medium Trials Fit', 'Hard Trials Fit');

hold off;