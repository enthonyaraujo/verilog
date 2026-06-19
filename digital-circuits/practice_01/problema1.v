module problema1(A,B,C,Z);
   // entradas 
   input A,B,C; 
   //saida 
   output Z; 

   // descrição por fluxo de dados
   assign Z = (~A&B) | (A|B) | (~B&C); //

endmodule 

