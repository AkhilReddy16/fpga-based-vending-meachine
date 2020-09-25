module clockdivider(clk_in,rst,clk_out);
input clk_in,rst;
output reg clk_out;
parameter sys_clk=100000000;
parameter dis_clk=1;
parameter max=(sys_clk/(2*dis_clk));
integer count;
initial
begin
count=0;
clk_out=0;
end
always@(negedge clk_in)
begin
    if(rst)
         begin
          clk_out=~clk_out;
          count=0;
      end
    else if(count==max-1)
    begin
        clk_out=~clk_out;
        count=0;
    end
    else
    count=count+1;
end
endmodule
module vending_machine(pr,ch,clk,coin,a,rst); 
output reg [1:0] pr,ch;
input  [1:0] coin;
input  a;
input  clk,rst; 
reg [2:0] state; 
reg [2:0] next_state; 
parameter [2:0] s0=3'b000; 
parameter [2:0] s1=3'b001; 
parameter [2:0] s2=3'b010; 
parameter [2:0] s3=3'b011; 
parameter [2:0] s4=3'b100; 
parameter [2:0] s5=3'b101; 
parameter [2:0] s6=3'b110; 
parameter [2:0] s7=3'b111; 
always @(posedge clk) 
   begin 
   if (rst) 
       state=s0; 
   else 
        state=next_state; 
   end 
always @(state,coin) 
begin 
   case (state) 
    s0: 
       begin 
       if (a==1'b0) 
           next_state=s1; 
       else if (a==1'b1)
           next_state=s2; 
       end 
    s1: 
       begin 
       if (coin==2'b01) 
           next_state=s3; 
       else if (coin==2'b10) 
           next_state=s4; 
       end 
    s2: 
       begin 
       if (coin==2'b01)
           next_state=s5; 
       else if (coin==2'b10) 
           next_state=s7; 
       end 
    s3: 
       begin 
           next_state=s0; 
       end 
    s4: 
       begin 
           next_state=s0;
       end
    s5: 
       begin 
       if (coin==2'b01) 
           next_state=s6;
       else if (coin==2'b10) 
           next_state=s4; 
       end 
    s6: 
       begin 
           next_state=s0; 
       end 
    s7: 
       begin 
           next_state=s0;
       end 
    default :
        next_state=s0; 
    endcase // case (state) 
 end
 always @ (state,next_state)  
 begin 
    case (state) 
    s0: 
       begin
        pr<=2'b00;
        ch<=2'b00;
       end 
    s1: 
       begin
        pr<=2'b00;
        ch<=2'b00;
       end
    s2: 
       begin
        pr<=2'b00;
        ch<=2'b00;
       end 
    s3: 
       begin
        pr<=2'b01;
        ch<=2'b00;
       end
    s4: 
       begin
       if(a==1'b0)
          begin
            pr<=2'b01;
            ch<=2'b01;
          end
       else if(a==1'b1)
           begin
             pr<=2'b10;
             ch<=2'b01;
           end
       end
    s5:
       begin
         pr<=2'b00;
         ch<=2'b00;
       end
    s6: 
       begin
         pr<=2'b10;
         ch<=2'b00;
       end
    s7: 
       begin
         pr<=2'b10;
         ch<=2'b00;
       end                    
    default: 
       begin
         pr<=2'b00;
         ch<=2'b00;
       end 
    endcase // case (state) 
end 
endmodule
module top(clk,sw,led);
input clk;
input [3:0]sw;
output [3:0]led;
wire ck;
clockdivider clk1(clk,sw[0],ck);
vending_machine v1({led[1],led[0]},{led[3],led[2]},ck,{sw[3],sw[2]},sw[1],sw[0]);
endmodule    