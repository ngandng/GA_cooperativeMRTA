
function y = Mutate(x, mu, m)
    
    nmu = ceil(mu*m); % number of chromosome will be mutated
    
    y = x;

    for i = 1:nmu
        y = MutateInAgent(y);
        y = MutateBetweenTwoAgents(y);
        % x = y; 
    end
    
end