function [ indices, cost ] = min_perfect_matching( G )
% Minimum Perfect Matching Tool
%
% Synopsis
%   [indices, cost] = min_perfect_matching( G ) 
%   
% Description
%   Function to solve the Minimum Perfect Matching on non-biparite graphs
%   problem using Integer linear programming.
%
%   Returns vector of matched indices and cost of the match. Requires
%   symmetric adjacent matrix of even rank.
% 
% Author: Vojtech Knyttl, knyttvoj@fel.cvut.cz

    %% dimensions
    if( ~isequal(G, G') )
      e = MException('PerfectMatching:MxNotSymetric', 'Matrix is not symmetric.' );
      throw(e);
    end;

    len = uint16(length( G ));
    if( mod(len,2) == 1 )
      e = MException('PerfectMatching:MxNotEvenRank', 'Matrix must be of even rank.' );
      throw(e);
    end;
    
    llen = (len*len)-len;
 
    %% function to minimize
    f = zeros(1,llen);
    for i=1:len-1
      f((i-1)*len+1:i*len)=G(i,:);
    end;
       
    %% respect matrix
    A = zeros(len,llen);
    for i=1:len
      for j=1:len*len-len
        idiv = idivide(j-1,len,'floor')+1;
        if idiv == i
          if and(mod(j-1,len)>=i,mod(j,len)~=i)
            A(i,j) = 1;
          end;
        elseif idiv < i
          if mod(j-1,len)+1==i
            A(i,j) = 1;  
          end;
        end;
      end;
    end;
    b = ones( len, 1 );
    
    %% removing zero columns
    remove_cols = find(all(A==0));
    f(:,remove_cols)=[];
    A(:,remove_cols)=[];
    
    %% glpk ilinprog settings
    sense=1;                            % minimization
    ctype = repmat( 'S', 1, len );      % equalities
    lb = zeros( llen/2, 1 );            % lower bound
    ub = ones( llen/2, 1 );             % upper bound
    i = 1:llen/2; 
    e=2^-24;
    % vartype = repmat( 'I', 1, llen/2 ); % integral vals
   % param.msglev = 1;  
   % param.itlim = 100;
    
    xmin = ilp(f,[],[],A,b,lb,ub,i,e)

    %xmin = glpk(f,A,b,lb,ub,ctype,vartype,sense,param);
    
    %% adding remove columns
    match = find(xmin==1)';
    
    for i=remove_cols
      match(match>=i)=match(match>=i)+1;
    end;
    
    %% forming the result
    indices = zeros(1,len); cost = 0;
    for i=match
      x = idivide(i-1,len,'floor')+1;
      y = mod(i-1,len)+1;
      indices(x)=y;
      indices(y)=x;
      cost = cost + G(x,y);
    end;
end