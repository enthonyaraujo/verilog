module problema3 ( a, b, c, d, e );

    // Declaracao das portas
    input a, b;
    output c, d, e;

    // Variaveis intermediarias
    wire na, nb;

    // Inversores
    not not0 (na, a);
    not not1 (nb, b);

    // Saida c: a < b
    and and0 (c, na, b);

    // Saida e: a > b
    and and1 (e, a, nb);

    // Saida d: a = b
    nor nor0 (d, c, e);

endmodule