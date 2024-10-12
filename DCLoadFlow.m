[r k]=size(B); %r and k are numbers of rows and columns in this matrix 
if r~=k || r==1 
    while r~=k || r==1 
    fprintf('Error! You need to enter square nXn matrix B!\n');

    B=input('Input matrix B that represents the supceptance matrix \n B=');
    end
end
[r k]=size(B); %we have to do it again because MATLAB remembers the previous wrong row and column parameters

%We use node 1 as reference every time
Bpom=B; %Bpom is just used to reduce the matrix B size by taking down row 1 and column 1
Bpom(1,:)=[];
Bpom(:,1)=[];
Br=Bpom;
Ppom=P;
Ppom(1)=[];
Pr=Ppom;
c=linsolve(-Br,Pr);
teta=[];
teta(1)=0; %reference

for i=2:length(Pr)+1
    teta(i)=c(i-1);
end
teta(abs(teta)<1e-15)=0;

fprintf('SOLUTION:\n');
fprintf('Angles in radians on the bus voltage phasors are:\n');
for i=1:r
    fprintf('teta%.d = %.3f rad  (%.3f degres)  \n',i,teta(i),rad2deg(teta(i)));
end


% W=index_sorting(r); %Special function for geting the unique indexes for active power values, for example 12 13 14 23 24 34 if there are 4 nodes
fprintf('Active power flows calculated by linear DC method are:\n');
for i = 1:num_line
    from = linedata(i, 1);
    to = linedata(i, 2);
    flow = abs((teta(from) - teta(to))/ linedata(i, 4)*100);
    fprintf('Line %d-%d: %.3f MW\n', from, to, flow);
end

