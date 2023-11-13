
function [y1, y2] = Crossover(x1, x2, model)

    n = length(x1.agents);
    
    % taskList = [];
    % for i=1:n
    %     taskList = [taskList, x1.agents(i).task];
    % end
    
    alpha = randi([1 n]); % crossover point

    % generate new solutions
    y1 = x1;
    y2 = x2;

    for i = alpha:n
        y1.agents(i) = x2.agents(i);
        y2.agents(i) = x1.agents(i);
    end

    y1 = Feasibilization(y1,model, 8);
    y2 = Feasibilization(y2,model, 8);

end