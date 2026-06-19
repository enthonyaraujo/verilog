module problema4 (
    A,
    B,
    A_maior_B,
    A_igual_B,
    A_menor_B
);

    // entradas de 4 bits
    input [3:0] A;
    input [3:0] B;

    // saidas de 1 bit
    output A_maior_B;
    output A_igual_B;
    output A_menor_B;

    // descrição por fluxo de dados
    assign A_maior_B = A > B;
    assign A_igual_B = A == B;
    assign A_menor_B = A < B;

endmodule

