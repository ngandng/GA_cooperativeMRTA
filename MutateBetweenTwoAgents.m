function y = MutateBetweenTwoAgents(x)

    y = x;

    nagent = length(x.agents);
    
    % choose two agents two exchange their tasks
    a = randi([1 nagent]);
    b = randi([1 nagent]);

    ca = setdiff(x.agents(a).task, x.agents(b).task);
    cb = setdiff(x.agents(b).task, x.agents(a).task);

    lenca = length(ca);
    lencb = length(cb);

    % disp(["lenca ", num2str(lenca)]);
    % disp(["lencb ", num2str(lencb)]);

    if(lenca==0 && lencb==0)
        % do nothing 
        return;
    elseif(lenca==0 && lencb>=1)
        % move task from b to a
        chooset = cb(randi([1 lencb]));
        pos = find(x.agents(b).task==chooset);

        y.agents(b).task(pos) = []; % remove task from b

        % add task before a random position in a
        posadd = randi([1 length(x.agents(a).task)]);
        if(posadd==1)
            y.agents(a).task = [chooset, y.agents(a).task];
        elseif(posadd==length(x.agents(a).task))
            y.agents(a).task = [y.agents(a).task, chooset];
        else
            y.agents(a).task = [y.agents(a).task(1:posadd-1), chooset, y.agents(a).task(posadd:end)];
        end

    elseif(lenca>=1 && lencb==0)
        % move task from a to b
        chooset = ca(randi([1 lenca]));
        pos = find(x.agents(a).task==chooset);

        y.agents(a).task(pos) = [];

        % add task before a random position in b
        posadd = randi([1 length(x.agents(b).task)]);
        if(posadd==1)
            y.agents(b).task = [chooset, y.agents(b).task];
        elseif(posadd==length(x.agents(b).task))
            y.agents(b).task = [y.agents(b).task, chooset];
        else
            y.agents(b).task = [y.agents(b).task(1:posadd-1), chooset, y.agents(b).task(posadd:end)];
        end

    else
        % exchange tasks between to agents
        choosea = ca(randi([1 lenca])); % get the id of exchange task
        chooseb = cb(randi([1 lencb]));

        pos1 = find(x.agents(a).task==choosea);
        pos2 = find(x.agents(b).task==chooseb);

        y.agents(a).task(pos1) = x.agents(b).task(pos2);
        y.agents(b).task(pos2) = x.agents(a).task(pos1);
    end

end