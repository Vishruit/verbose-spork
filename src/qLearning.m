function [ action ] = qLearning( obsState, lastReward )
%Qlearning Learning to select options and navigate, one step at a time.
% Arguments: Observed state, position, reward from last action.
% Overview: Options: --Explore --Go to fruit --Choose between fruit to go
% to.
% TODO: Everything
% Exploitation of multiple good things

%% Pre computation

% Actions: 1-Move forward, 2-Turn Right by turnRate\deg, 3-Turn Left 
% by turnRate\deg, and 4-Turn back 180\deg (NOT IMPLEMENTED)
global turnRate WALL previousState previousAction theta;
turnRate = 45;
j=0;
epsilon = 0.1;
learningRate = 0.3;
discountFactor = 0.9;

% Check if theta values are in workspace. Initialize otherwise.
if(isempty(theta))
    % Each of the possible states have action values
    theta = zeros(eyes,numThings);
end

%% Selecting next action
% Get distance to closest good thing
closestGoodDistance = Inf;
closestGoodDirection = 0;
for i=1:eyes
    if(obsState(i) < closestGoodDistance)
        closestGoodDistance = obsState(i);
        closestGoodDirection = i;
    end
end
if(closestGoodDirection == 0)
    % Explore (TODO Go to last known good thing)
    % Fixed policy: Straight until we hit wall, turn until we no longer face wall, keep
    % going.
    global turningActions;
    if(turningActions~=0) 
        action = 2; 
        turningActions = turningActions -1;
    elseif(obsState(5,WALL)<Inf)
        % Randomly choose an anglue to turn between turnRate and 180
        turningActions = randi(3); 
        action = 2;
    else 
        action = 1;
    end
else
    % Collect good thing
    action = getGreedyAction(obsState, theta);
end

%% Updating from observed reward
% If previousState exists, update it.
if(isempty(previousState)==0)
    if newState ~= state
        delta = lastReward + actionValueApprox(obsState,action) - actionValueApprox(previousState,previousAction);
        i = actionToEye(previousAction);
        [tmp j] = min(previousState(i,:));
        theta(i,j) = theta(i,j) + learningRate * delta * gradActionValue_wrtTheta(previousState,[i j]);
    end
end


%% Post computation
previousState = obsState;
previousAction = action;

end
