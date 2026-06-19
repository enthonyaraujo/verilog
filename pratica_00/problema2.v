module problema2 ( a, b, sel, y );

    // Declaracao das portas
    input [3:0] a, b;
    input sel;
    output [3:0] y;

    // Variaveis intermediarias
    wire nsel;
    wire [3:0] p1, p2;

    // Inversao do sinal de selecao
    not not0 (nsel, sel);

    // Multiplexador do bit 0
    and and0 (p1[0], a[0], nsel);
    and and1 (p2[0], b[0], sel);
    or  or0  (y[0], p1[0], p2[0]);

    // Multiplexador do bit 1
    and and2 (p1[1], a[1], nsel);
    and and3 (p2[1], b[1], sel);
    or  or1  (y[1], p1[1], p2[1]);

    // Multiplexador do bit 2
    and and4 (p1[2], a[2], nsel);
    and and5 (p2[2], b[2], sel);
    or  or2  (y[2], p1[2], p2[2]);

    // Multiplexador do bit 3
    and and6 (p1[3], a[3], nsel);
    and and7 (p2[3], b[3], sel);
    or  or3  (y[3], p1[3], p2[3]);

endmodule