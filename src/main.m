% Generate Environment
EnvState = 0;
[EnvState, ~] = EnvironmentModel(EnvState, 1);

% Start the bot
pos = [1 1];
vec = [0 1];
vec = vec / norm(vec);
obsEnv = observableEnv(EnvState, pos, vec);
action = squareAgent(obsEnv, 0);
        
max_steps = 10000;
frame = 100;
steps = 0;
%avgRewardPlot = plot(nan);
%hold on;
%X = get(avgRewardPlot, 'XData');
%Y = get(avgRewardPlot, 'YData');
while steps<=max_steps
    avgReward = 0;
    for i=1:100
        obsEnv = observableEnv(EnvState, EnvState(1,[1 2]), EnvState(1,[3 4]));
        action = squareAgent(obsEnv);
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        avgReward = avgReward+reward;
        steps = steps+1;
    end
    avgReward = avgReward/100;
    %set(avgRewardPlot, 'XData', [X round(steps/100)], 'YData', [Y avgReward]);
    %drawnow
end
