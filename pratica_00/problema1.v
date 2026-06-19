module problema1 (
    input  wire A,
    input  wire B,
    input  wire C,
    output wire Z
);

    // Saídas das portas NOT
    wire not_A;
    wire not_B;
    wire not_C;

    // Saídas das portas intermediárias
    wire and_1;
    wire or_1;
    wire and_2;

    // Inversores
    not NOT_A(not_A, A);
    not NOT_B(not_B, B);
    not NOT_C(not_C, C);

    // Termo: ~AB
    and AND_1(and_1, not_A, B);

    // Termo: A + ~C
    or OR_1(or_1, A, not_C);

    // Termo: ~BC
    and AND_2(and_2, not_B, C);

    // Saída Z
    or OR_FINAL(Z, and_1, or_1, and_2);

endmodule