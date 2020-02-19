
trying=[0 4 6 9;
        4 0 7 3;
        6 7 0 2;
        9 3 2 0]
               
node=[1;2;3;4]

graph=Containers.DenseAxisArray(trying,node,node)

q=Model(with_optimizer(GLPK.Optimizer))

@variable(q,path[node,node])

@objective(q,Min,sum(graph[i,j]*path[i,j] for i in node,j in node))

@constraint(q,[i in node],sum(path[i,j] for j in node)==1)

@constraint(q,[j in node],sum(path[i,j] for i in node)==1)
 
@constraint(q,[i in node,j in node],path[i,j]+path[j,i]<=1)
 
@constraint(q,[i in node,j in node],path[i,j]>=0)
 
@constraint(q,[i in node],path[i,i]==0)
 
optimize!(q)
 
value.(path)
 
 0.0  0.0  1.0  0.0
 1.0  0.0  0.0  0.0
 0.0  0.0  0.0  1.0
 0.0  1.0  0.0  0.0
 
objective_value(q)
 
 15.0
 
 t=Tuple{Int,Int}[]
 
for i in node
    for j in node
       if value.(path[i,j])!=0
       print(i,",",j," ")
       push!(t,(i,j))
       end
    end
end
       
t

 (1, 3)
 (2, 1)
 (3, 4)
 (4, 2)
 
y=Tuple{Int,Int}[]
 
push!(y,t[1])
  
for i in 1:4
    for j in 2:4
       if t[i][2]==t[j][1]
       push!(y,t[j])
       end
    end
end
       
y

 (1, 3)
 (3, 4)
 (4, 2)
 (2, 1)
