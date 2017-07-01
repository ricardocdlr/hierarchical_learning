%{
INPUT:
y_hat: data point y-value
vector: data point x-values
tree: structure representing aggregate levels; input [] if new tree

OUTPUT:
tree: updated tree
%}

function [tree] = hierarchical(y_hat, tree, vector)

if isempty(tree)
    tree = Tree(length(vector));
end
 
% Train aggregation levels
add(tree, vector, y_hat);
 
% Combine aggregate levels for vector
% disp(return_mu(tree, vector))

end