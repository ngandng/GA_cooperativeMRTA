
function newSol = MutateInAgent(sol)
    
    newSol = sol;
    lenS = length(sol.agents);

    if (lenS == 1)
        return;
    end

    ag = randi([1 lenS]);

    numTask = length(sol.agents(ag).task);

    if (numTask <= 1)
        return;
    end
    
    % random two task in one agent
    pos1 = randi([1 numTask]);
    pos2 = randi([1 numTask]);

    while (pos2 == pos1)
        % disp("trung");
        pos2 = randi([1 numTask]);
    end

    newSol.agents(ag).task(pos1) = sol.agents(ag).task(pos2);
    newSol.agents(ag).task(pos2) = sol.agents(ag).task(pos1);

end