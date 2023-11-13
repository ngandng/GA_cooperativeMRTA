
% Initialize some assignment

function pop = InitAssignment(model)
    
    %set of available tasks
    avai_tasks = [];

    for i = 1:model.M
        for j = 1:model.tasks(i).req
            avai_tasks = [avai_tasks, model.tasks(i).id];
        end
    end

    for i=1:(model.N)  % for each agent
        pop.agents(i).task = [];
    end

    % avai_tasks
    for i = 1:length(avai_tasks)
        id = avai_tasks(i);
        isassigned = false;
        while(~isassigned)
            ag = randi([1 model.N]); % choose a random agent to carry the task

            if isempty(find(pop.agents(ag).task==id))
                pop.agents(ag).task = [pop.agents(ag).task, id];
                isassigned = true;
            end
        end
    end

end