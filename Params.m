%% Params

classdef Params < handle
   properties
      V
      MuAgg
      Bias
      S
      Lambda
      Sigma
      N
   end
   methods
       function obj = Params(stp_sz)
           obj.N = 1;
           obj.V = 0;
           obj.MuAgg = 0;
           obj.Bias = 0;
           obj.S = 0;
           obj.Lambda = stp_sz^2;
           obj.Sigma = 0;
       end
   end
end