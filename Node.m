%% Node

classdef Node < handle
   properties
      Parent
      Children
      VectorEntry
      Depth
      Par
   end
   methods
      function obj = Node(is_root, parent, vec_entry)
         obj.Par = Params(0.9);
         obj.Children = [];
         if is_root == false
            obj.Parent = parent;
            obj.Parent.Children = [obj.Parent.Children obj];
            obj.Depth = obj.Parent.Depth + 1;
            obj.VectorEntry = vec_entry(obj.Depth);
         elseif is_root == true
             obj.Depth = 0;
         end
      end
      
      function leaf = find_leaf(root, vec)
          if isempty(root.Children)
              leaf = root;
          else
              parent = root;
              target = 0;
              for i=1:length(parent.Children)
                  if parent.Children(i).VectorEntry == vec(parent.Children(i).Depth)
                      target = parent.Children(i);
                  end
              end
              if target ~= 0
                leaf = find_leaf(target, vec);
              else
                leaf = parent;
              end
          end
      end
      
      function update_node(leaf, node, y_hat)
          stp_sz1 = 0.9;
          stp_sz2 = 0.1;
          
          node.Par.V = (1-stp_sz2)*node.Par.V + stp_sz2*(node.Par.MuAgg - y_hat)^2;
          node.Par.MuAgg = (1-stp_sz1)*node.Par.MuAgg + stp_sz1*y_hat;
          node.Par.Bias = node.Par.MuAgg - leaf.Par.MuAgg;
          node.Par.S = (node.Par.V - node.Par.Bias^2)/(1+node.Par.Lambda);
          if node.Par.N > 1
              node.Par.Lambda = (1-stp_sz1)^2*node.Par.Lambda + stp_sz1^2;
          end
          node.Par.N = node.Par.N + 1;
      end
      
      function update_branch(leaf, root, vec, y_hat)
          stp_sz1 = 0.9;
          stp_sz2 = 0.1;
          
          % Update root parameters
          update_node(leaf, root, y_hat)
          
          % Update rest of branch parameters
          parent = root;
          target = parent.Children(1);
          for j=1:length(vec)
            for i=1:length(parent.Children)
                if parent.Children(i).VectorEntry == vec(parent.Children(i).Depth)
                    target = parent.Children(i);
                end
            end
            % Update child parameters
            update_node(leaf, target, y_hat)
            parent = target;
          end
      end
      
      function update_sigma(root)
          root.Par.Sigma = root.Par.Lambda*root.Par.S^2;
          if ~isempty(root.Children)
            for i=1:length(root.Children)
                  update_sigma(root.Children(i));
            end
          end
      end
      
      function norm = find_norm(root, vec)
          if isempty(root.Children)
              norm = 1/(root.Par.Sigma^2 + root.Par.Bias^2);
          else
              parent = root;
              target = 0;
              for i=1:length(parent.Children)
                  if parent.Children(i).VectorEntry == vec(parent.Children(i).Depth)
                      target = parent.Children(i);
                  end
              end
              if target ~= 0
                norm = 1/(root.Par.Sigma^2 + root.Par.Bias^2) + find_norm(target, vec);
              else
                norm = 1/(root.Par.Sigma^2 + root.Par.Bias^2);
              end
          end
      end
      
      function mu = calc_mu(norm, root, vec)
          if isempty(root.Children)
              mu = root.Par.MuAgg*(1/(root.Par.Sigma^2 + root.Par.Bias^2))/norm;
          else
              parent = root;
              target = 0;
              for i=1:length(parent.Children)
                  if parent.Children(i).VectorEntry == vec(parent.Children(i).Depth)
                      target = parent.Children(i);
                  end
              end
              if target ~= 0
                mu = root.Par.MuAgg*(1/(root.Par.Sigma^2 + root.Par.Bias^2))/norm + calc_mu(norm, target, vec);
              else
                mu = root.Par.MuAgg*(1/(root.Par.Sigma^2 + root.Par.Bias^2))/norm;
              end
          end
      end
   end
end
