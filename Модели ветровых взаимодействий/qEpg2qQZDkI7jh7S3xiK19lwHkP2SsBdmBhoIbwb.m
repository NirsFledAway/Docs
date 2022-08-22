function vixod =VETERR(u)
ykr=u(1); ta=u(2); kyr=u(3); %изменяем крен, тангаж, курс. 
va=u(4); % воздушная скорость без ветра
vay=0; vaz=0;
V=[va;vay;vaz];
%******************************************* 
bb11=cos(kyr)*cos(ykr)-sin(kyr)*sin(ta)*sin(ykr);    
bb12=cos(ta)*sin(ykr);                               
bb13=cos(kyr)*sin(ykr)+sin(kyr)*sin(ta)*cos(ykr);    

bb21=sin(kyr)*cos(ykr)+cos(kyr)*sin(ta)*sin(ykr); 
bb22=cos(ta)*cos(kyr);                           
bb23=sin(kyr)*sin(ykr)-cos(kyr)*sin(ta)*cos(ykr); 
%---------------------------------------
bb31=-cos(ta)*sin(ykr); 
bb32=sin(ta);                     
bb33=cos(ta)*cos(ykr);  
%---------------------------------------
B3=[bb11 bb12 bb13; bb21 bb22 bb23; bb31 bb32 bb33];
P3=[0 0 1; 1 0 0;0 1 0];% перестановочная матрица
P3tr=P3'; 
Wxyz=(P3tr*B3*P3)*V;
%*****************************************
vixod(1)=Wxyz(1);
vixod(2)=Wxyz(2);
vixod(3)=Wxyz(3);