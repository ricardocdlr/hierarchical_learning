disp('Test Tree')
tree = hierarchical(-5, [], [2,0]);
for i=1:10
    tree = hierarchical(1, tree, [0,0]);
    tree = hierarchical(10, tree, [1,0]);
    tree = hierarchical(100, tree, [0,1]);
    tree = hierarchical(110, tree, [1,1]);
    
    tree = hierarchical(1.5, tree, [0,0]);
    tree = hierarchical(10.5, tree, [1,0]);
    tree = hierarchical(100.5, tree, [0,1]);
    tree = hierarchical(111, tree, [1,1]);
    
    tree = hierarchical(0.5, tree, [0,0]);
    tree = hierarchical(9.5, tree, [1,0]);
    tree = hierarchical(99.5, tree, [0,1]);
    tree = hierarchical(109, tree, [1,1]);
end

disp('True Value: 1')
disp(return_mu(tree, [0,0]))
disp('True Value: 10')
disp(return_mu(tree, [1,0]))
disp('True Value: 100')
disp(return_mu(tree, [0,1]))
disp('True Value: 110')
disp(return_mu(tree, [1,1]))
disp('True Value: -5')
disp(return_mu(tree, [2,2]))
disp('Guessed Value: -5')
disp(return_mu(tree, [2,1]))

% Bug due to initialization of parameters to 0
disp('Bug Tree')
bug_tree =  hierarchical(0, [], [0,0,0]);
disp(return_mu(bug_tree, [0,0,0]))
disp(return_mu(bug_tree, [1,1,1]))

bug_tree =  hierarchical(0, bug_tree, [0,1,0]);
disp(return_mu(bug_tree, [0,0,0]))
disp(return_mu(bug_tree, [1,1,1]))

% Putting the first non-zero entry "stops" the bug
% by making the variaton non-zero
bug_tree =  hierarchical(1, bug_tree, [0,0,0]);
disp(return_mu(bug_tree, [0,0,0]))
disp(return_mu(bug_tree, [1,1,1]))