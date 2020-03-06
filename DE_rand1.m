%Differential Evolution algorithm
%Based on:
%Mallipedi, Suganthan - Differential evolution algorithm with ensemble of parameters and mutation strategies.pdf


function [Xopt,Xgen,objf_perf_min]=DE_rand1(NP,n_gen,F,CR,Xbound,objf_var,objf_k)


%Number of population members to be combined for mutation (defined by the selected approach)
nr=3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial population of target vectors

%Number of parameters to be optimized
nX=size(Xbound,2);

%Define initial population of target vectors
Xinit=zeros(nX,NP);

for i=1:nX
	Xinit(i,:)=Xbound(1,i)+random('Uniform',0,1,[1 NP])*(Xbound(2,i)-Xbound(1,i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Optimal paramaters search

%Initialization
X=Xinit;
Xopt=zeros(nX,1);
Xgen=zeros(nX,NP,n_gen);
V=zeros(nX,NP);
U=zeros(nX,NP);
objf_perf_min=zeros(objf_k.n_objf_perf,1);
f_min=Inf;
f_min_old=Inf;
df=100;
k_fmin=1;
ng=1;


%Until all generations are evaluated and the objective function continue decreasing
while ng<=n_gen && df>=objf_k.df_lim   
  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Mutation    
    
    %For each target vector X
    for j=1:NP
        
        %Find mutually esclusive integers r in the range [1 NP]
        
        %Initialization of the index of the random elements to be selected
        r=round(random('Uniform',1,NP))*ones(1,nr);
        
        %Initalization
        exit=0;
        k=2;
        
        while exit==0
            
            %Trial number
            r_try=round(random('Uniform',1,NP));
            
            %If the trial number is different to all the elements in r and to j
            if sum(r_try==r)==0 && r_try~=j
                
                %Assign new number
                r(k)=r_try;
                k=k+1;
                
                %If last element is found
                if k>nr
                    exit=1;
                end
            end
            
        end        
        
        %Define mutant vector
        V(:,j)=X(:,r(1))+F*(X(:,r(2))-X(:,r(3)));
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Crossover - Binomial approach    
        
    %For each element of target-mutant vector pair    
    for j=1:NP
        
        %Generate random parameter index
        i_rand=round(random('Uniform',1,nX));
        
        %For each parameter target-mutant vector pair 
        for i=1:nX
            
            %Define trial vector
            if rand<=CR || i==i_rand
                U(i,j)=V(i,j);
            else
                U(i,j)=X(i,j);
            end
            
            %Random reinitialization if boundaries are crossed
            if U(i,j)<Xbound(1,i) || U(i,j)>Xbound(2,i)
                U(i,j)=Xbound(1,i)+rand*(Xbound(2,i)-Xbound(1,i));
            end
            
        end
    end
        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Objective function evaluation
    
    
    %Evaluate the objective function for each target-trial vector pair 
    for j=1:NP
            
        %Evaluate the objective function
        [f_x,objf_out_x]=eval_obj_fun(X(:,j),objf_var,objf_k);
        [f_u,objf_out_u]=eval_obj_fun(U(:,j),objf_var,objf_k);
               
                
        %If objective function value reduces, replace the target vector with the trial vector
        if f_u<f_x
            X(:,j)=U(:,j);
        end
        
        
        %Update objective function values and parameters
        if f_u<f_x && f_u<f_min
            
            %Update minimum objective function values
            f_min=f_u;
            df=100*(f_min_old-f_min)/f_min;
            f_min_old=f_min;
            
            %Update optimal target vector
            Xopt=U(:,j);
            
            %Record objective function elements values
            objf_perf_min(:,k_fmin)=cell2mat(struct2cell(objf_out_u));
            
            %Update index
            k_fmin=k_fmin+1;            
            
        elseif f_x<=f_u && f_x<f_min
            
            %Update minimum objective function values
            f_min=f_x;
            df=100*(f_min_old-f_min)/f_min;
            f_min_old=f_min;
            
            %Update optimal target vector
            Xopt=X(:,j);
            
            %Record objective function elements values
            objf_perf_min(:,k_fmin)=cell2mat(struct2cell(objf_out_x));
            
            %Update index
            k_fmin=k_fmin+1;
            
        end
        
    end        
    
    
    %Record population at each generation
    Xgen(:,:,ng)=X;
    
    %Update iteration number
    ng=ng+1;    
    
end

