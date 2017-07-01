%% Tree

classdef Tree < handle
   properties
      Root
      G
   end
   methods
       function obj = Tree(g)
           obj.Root = Node(true, [], []);
           obj.G = g;
       end
       
       function add(tree, vec_entry, y_hat)
           % Build branch
           leaf = find_leaf(tree.Root, vec_entry);
           while leaf.Depth < tree.G
               leaf = Node(false, leaf, vec_entry);
               % Not appending to children, overwriting?
           end
           
           % Update parameters           
           update_branch(leaf, tree.Root, vec_entry, y_hat)
           
           % Update sigma parameters
           update_sigma(tree.Root);
       end
       
       function mu = return_mu(tree, vec_entry)
          norm = find_norm(tree.Root, vec_entry);
          mu = calc_mu(norm, tree.Root, vec_entry);
       end
   end
end