% Cost function

function cost = CostFunction(asg, model)

    N = length(asg.agents);
    % vel = 0.5*ones([1 N]); % velocity of the robots m/s
    vel = [model.agents(:).nom_vel];
 
    %% F1 total travel distance
    F1 = 0;
    d_agent = zeros([1 N]);
    for i = 1:N
        % Calculate traveling distance for each agent
        ntask = length(asg.agents(i).task);

        if(ntask == 0) % if no task assigned for that agent
            d_agent(i) = 0;
            F1 = F1 +d_agent(i);
            continue;
        end

        vtask = asg.agents(i).task; % get the task vector
        
        taskID = vtask(1);

        d_agent(i) = 0; % fitness function
        
        d_agent(i) = d_agent(i) + Distance(model.agents(i).x, model.agents(i).y, model.agents(i).z, ...
                                     model.tasks(taskID).x, model.tasks(taskID).y, model.tasks(taskID).z); % from robot position to task 1;
        for j = 1: ntask
            prePos = taskID;
            taskID = vtask(j);

            dis = Distance(model.tasks(prePos).x, model.tasks(prePos).y, model.tasks(prePos).z, ...
                           model.tasks(taskID).x, model.tasks(taskID).y, model.tasks(taskID).z); % distance from task to task
            d_agent(i) = d_agent(i) + dis;
        end
        F1 = F1 +d_agent(i);
    end

    %% F2 time traveling
    F2 = 0;
    times  = zeros([1 N]);
    for i = 1:N
        ntask  = length(asg.agents(i).task);
        ttime = 0;
        for j = 1:ntask
            taskid = asg.agents(i).task(j);
            ttime = ttime + model.tasks(taskid).duration;
        end
        times(i) = d_agent(i)/vel(i) + ttime;
    end
    F2 = max(times);

    cost  = F1 + F2;
end