# Traveling Salesman

The traveling salseman problem is a classic problem.  The problem states that a salesman must start at a certain 
city and visit a list of other cities.  All of the other cities must be visited.  The city started at is the salesman's
starting point and needs to be returned to last.  The objective is to minimize the total distance traveled.  For this 
example four nodes are chosen.
```
node=[1;2;3;4]

trying=[0 4 6 9;
        4 0 7 3;
        6 7 0 2;
        9 3 2 0]

 graph=Containers.DenseAxisArray(trying,node,node)
```
The matrix is the distances between the nodes.  The distances also create a symmetric matrix.  The nodes cannot travel to 
themselves so they are 0.  Next a model will be made using the GLPK solver because integer values are needed to be able 
to show a one for each position that is selected.  The constraints will be chosen to produced results needed.
```
q=Model(with_optimizer(GLPK.Optimizer))

@variable(q,path[node,node])

@objective(q,Min,sum(graph[i,j]*path[i,j] for i in node,j in node))

@constraint(q,[i in node],sum(path[i,j] for j in node)==1)

@constraint(q,[j in node],sum(path[i,j] for i in node)==1)
 
@constraint(q,[i in node,j in node],path[i,j]+path[j,i]<=1)
 
@constraint(q,[i in node,j in node],path[i,j]>=0)
 
@constraint(q,[i in node],path[i,i]==0)
```
The salesman must leave each node that he travels to.  Each node must be visited once.  Now the objective will be stated and 
solved.
```
@objective(q,Min,sum(graph[i,j]*path[i,j] for i in node,j in node))
optimize!(q)

value.(path)
 
 0.0  0.0  1.0  0.0
 1.0  0.0  0.0  0.0
 0.0  0.0  0.0  1.0
 0.0  1.0  0.0  0.0
 
 objective_value(q)
 
 15.0
 ```
 The total distance traveled is 15.  The minized path is from node 1 to 3,node 2 to 1,node 3 to 4 and node 4 to 2. 
 This is out of order.  The correct path is 1->3->4->2->1.  The distances can be iterated for each index that is on the path.
 ```
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
 ```
 The paths between nodes are listed now but are out of order and appear unconnected.  Another tuple is needed for the 
 nodes traveled to be in the correct order.
 ```
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
 ```
 Now the nodes traveled are in order.  Starting at node 1->3->4->2->1.  The node started at is returned to with the 
 shortest distance traveled.
