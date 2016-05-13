close all % To close the figures
clear all %TODO remove if coming from previous theta. Add to options, like debug.
global dbg sideWings vec moveSlow gridSize axPosition axReward positionPlot quiverPlot quiverSidePlot eyes blobsEaten;
dbg = str2num(input('Do you want to debug = ','s'));
moveSlow = str2num(input('Do you want the agent to move slowly(Press 1 for yes) = ','s'));
sideWings = str2num(input('Do you want to sideWings displayed? (Press 1 for yes) ','s'));
init;

% Setting up axes for the plots and hold 'on'
axPosition = subplot(3,3,[1 2 3 4 5 6]);
axReward = subplot(3,3,[7 8 9]);
hold(axPosition,'on');
hold(axReward,'on');

% Initializing the plots
positionPlot(1) = plot(axPosition,0,0); % Good consumable handle
positionPlot(2) = plot(axPosition,0,0); % Bad consumable handle
quiverPlot = quiver(axPosition,50,50,1,0);
for i = 1:eyes
    quiverSidePlot(i) = quiver(axPosition, 0,0,0,0);
end
avgRewardPlot = plot(axReward, nan, 'b*');
X = get(avgRewardPlot, 'XData');
Y = get(avgRewardPlot, 'YData');

% Initialize the bot's position in the space
pos = [round(gridSize/2) round(gridSize/2)];
vec = [1 0]; % Changed from [0 1] to be coherent (inherent direction)
vec = vec / norm(vec);

% Generate Environment
EnvState = 0;
[EnvState, ~] = EnvironmentModel(EnvState, 1);

% Start the bot
obsEnv = observableEnv(EnvState, pos, vec);
action = squareAgent(obsEnv, 0);

max_steps = 10000;
frame = 100; % We display averages over this frame
steps = 0;

if dbg == 1 
    display('In main: before while');
end
j=0;
while steps<=max_steps
    if dbg == 1 
        display(['Steps(Age): ' num2str(steps)]);
        display(['Action taken last step: ' num2str(action)]);
        display(obsEnv);
    end
%     axes(axPosition);
    avgReward = 0;
    for i=1:frame
        obsEnv = observableEnv(EnvState, EnvState(1,[1 2]), EnvState(1,[3 4]));
        action = squareAgent(obsEnv, reward);
        [EnvState, reward] = EnvironmentModel(EnvState, action);
        avgReward = avgReward+reward;
        steps = steps+1;
        if moveSlow && dbg
            display(obsEnv);
            display(reward);
        end
    end
    avgReward = avgReward/frame;
    % To display all the previous points in the plot.
    j=j+1;
    temp1(j) = round(steps/frame);
    temp2(j) = avgReward;
    set(avgRewardPlot, 'XData', [X temp1], 'YData', [Y temp2]);
    hold on
    drawnow
end
