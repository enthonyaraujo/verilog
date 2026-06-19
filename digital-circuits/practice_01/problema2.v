module problema2 (A,B,S,Y);

    // entradas
    input [3:0] A;
    input [3:0] B;
    input       S;

    // saida
    output [3:0] Y;

    // descrição por fluxo de dados
    assign Y = S ? B : A;

endmodule