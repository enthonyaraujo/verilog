module problema3 (A,B,Cin,Cout,S);
    // entradas
    input A,B,Cin;

    //saidas
    output Cout,S;

    // descrição por fluxo de dados
    assign S = A ^ B ^ Cin;
    assign Cout = (A&B) | (B&C) | (A&Cin);
endmodule