
% check the directed acyclic graph constraint
function isdag = IsDAG(sol, model)

    % covert solution to a graph
    adjMatrix = zeros(model.M, model.M);

    for i = 1:length(sol.agents)
        for j = 1:(length(sol.agents(i).task)-1)
            a = sol.agents(i).task(j);      % current task
            b = sol.agents(i).task(j+1);    % next task
            adjMatrix(a,b) = 1;
        end
    end
    % adjMatrix
    % check the graph
    G = digraph(adjMatrix);

    try
        order = toposort(G);
        isdag = ~isempty(order); % return 1 if it is an DAG
        % disp(['This is a DAG ' num2str(isdag)]);
    catch
        isdag = false;           % return 0 if the graph contains a cycle
    end
end

%% Test
% for i = 1:nPop
%     isdag = IsDAG(pop(i).Position);
%     disp(num2str(isdag));
% end