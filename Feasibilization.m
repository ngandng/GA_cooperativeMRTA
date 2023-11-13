
% adjust solution to be feasible
function newSol = Feasibilization(sol, model, beta)
    
    numTask = model.M;
    
    task_check = [];

    % an agent cant hold a task two times
    for i = 1:model.N
        sol.agents(i).task = unique(sol.agents(i).task);
    end    

    newSol = sol;

    % create the list for count the number of holders for each task
    for i = 1:numTask
        
        task_check(i).id = model.tasks(i).id;
        task_check(i).req = model.tasks(i).req;
        task_check(i).holder = [];

        for j = 1:model.N                                             % model.N is number of agent
            
            for k = 1:length(sol.agents(j).task)                   % for each task in agent(j)
               if sol.agents(j).task(k) == task_check(i).id 
                    task_check(i).holder = [task_check(i).holder, j];
                    break;
               end
            end
        end
    end
    
    % Adjust the solution due to the list
    for i = 1:numTask

        % if the task is carried by more required
        if length(task_check(i).holder) > task_check(i).req 
            
            for k = 1:task_check(i).req
                prob = zeros(1,length(task_check(i).holder));
                
                for j = 1 : length(task_check(i).holder) % for each holder
    
                    idh = task_check(i).holder(j);       % get id of holder
                    nh = length(sol.agents(idh).task);   % number of tasks carried by this holder
    
                    prob(j) = exp(-beta*nh);             % probability of agent choosed to keep the task
                end
    
                prob = prob/sum(prob);                   % standardlization
                
                idx = task_check(i).holder;              % idx: list of agents choosed to carry the task
            
                ic = RouletteWheelSelection(prob);
                idx(ic) = [];                            % idx is list of agent should be drop the task
                task_check(i).holder = idx;
            end

            for in = 1 : length(idx)
                for k = 1 : length(newSol.agents(in).task)

                    if newSol.agents(in).task(k) == task_check(i).id    % delete task in agent solution
                        
                        if k == 1
                            newSol.agents(in).task = [newSol.agents(in).task(2:end)];
                            % after_remove = newSol.agents(in).task
                            break;
                        elseif k == length(newSol.agents(in).task)
                            newSol.agents(in).task = [newSol.agents(in).task(1:k-1)];
                            % after_remove = newSol.agents(in).task
                            break;
                        else
                            newSol.agents(in).task = [newSol.agents(in).task(1:k-1), newSol.agents(in).task(k+1:end)];
                            % after_remove = newSol.agents(in).task
                            break;
                        end
                        % after_remove = newSol.agents(in).task
                    end
                end

            end
        end

        % if this task is not carried by number of required agents
        if length(task_check(i).holder) < task_check(i).req 
            
            prob_a = [];                             % prob of agents to carry this task

            for it = 1:length(newSol.agents)
                
                nh = length(newSol.agents(it).task); % number of tasks carried by this holder
                prob_a(it) = exp(-beta*nh);          % probability of agent choosed to keep the task
            end
            
            prob_a = prob_a/sum(prob_a);             % standardlization

            for j = 1:(task_check(i).req-length(task_check(i).holder))
                isassigned = false;
                while(~isassigned)
                    % icd = RouletteWheelSelection(prob_a); % id of agent choosed to hold the task
                    icd = randi([1 model.N]);
        
                    if isempty(find(newSol.agents(icd).task==task_check(i).id))
                        newSol.agents(icd).task = [newSol.agents(icd).task, task_check(i).id];
                        isassigned = true;
                        % disp(["isassigned: -> " num2str(isassigned)]);
                    end
                end
                task_check(i).holder = [task_check(i).holder, icd];
            end
            
        end

    end

end