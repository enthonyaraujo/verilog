# Hardware Description Language (HDL) e Verilog

## Sumário

- [Hardware Description Language (HDL) e Verilog](#hardware-description-language-hdl-e-verilog)
  - [Sumário](#sumário)
  - [1. Linguagens de Descrição de Hardware](#1-linguagens-de-descrição-de-hardware)
  - [2. Fluxo de desenvolvimento com HDL](#2-fluxo-de-desenvolvimento-com-hdl)
  - [3. Estrutura básica de um módulo Verilog](#3-estrutura-básica-de-um-módulo-verilog)
  - [4. Portas, fios e registradores](#4-portas-fios-e-registradores)
    - [4.1 Portas](#41-portas)
    - [4.2 Fios](#42-fios)
    - [4.3 Registradores e variáveis procedurais](#43-registradores-e-variáveis-procedurais)
  - [5. Formas de descrição de circuitos](#5-formas-de-descrição-de-circuitos)
  - [6. Descrição estrutural](#6-descrição-estrutural)
    - [Exemplo: porta XOR estrutural](#exemplo-porta-xor-estrutural)
  - [7. Descrição por fluxo de dados](#7-descrição-por-fluxo-de-dados)
    - [7.1 Constantes](#71-constantes)
    - [7.2 Seleção de partes de vetores](#72-seleção-de-partes-de-vetores)
    - [7.3 Operadores lógicos bit a bit](#73-operadores-lógicos-bit-a-bit)
    - [7.4 Operadores relacionais](#74-operadores-relacionais)
    - [7.5 Deslocamento](#75-deslocamento)
    - [7.6 Concatenação e replicação](#76-concatenação-e-replicação)
    - [7.7 Operadores aritméticos](#77-operadores-aritméticos)
    - [7.8 Operador ternário](#78-operador-ternário)
    - [Exemplo: porta XOR por fluxo de dados](#exemplo-porta-xor-por-fluxo-de-dados)
  - [8. Descrição hierárquica](#8-descrição-hierárquica)
    - [Mapeamento por posição](#mapeamento-por-posição)
    - [Mapeamento por nome](#mapeamento-por-nome)
  - [9. Descrição comportamental](#9-descrição-comportamental)
    - [9.1 Bloco `initial`](#91-bloco-initial)
    - [9.2 Bloco `always`](#92-bloco-always)
    - [9.3 Atribuição bloqueante e não bloqueante](#93-atribuição-bloqueante-e-não-bloqueante)
    - [9.4 Estrutura `if-else`](#94-estrutura-if-else)
    - [9.5 Estrutura `for`](#95-estrutura-for)
    - [9.6 Estrutura `case`](#96-estrutura-case)
  - [10. Máquinas de estados finitos](#10-máquinas-de-estados-finitos)
  - [11. Descrição de memórias](#11-descrição-de-memórias)

---

## 1. Linguagens de Descrição de Hardware

Uma **HDL** é uma linguagem utilizada para representar o funcionamento e a estrutura de circuitos digitais. Diferentemente de uma linguagem de programação convencional, uma HDL descreve componentes de hardware que podem operar simultaneamente.

As HDLs permitem:

- modelar circuitos digitais de forma textual;
- simular o funcionamento antes da implementação física;
- verificar a lógica e corrigir erros;
- sintetizar o código para FPGA, CPLD ou ASIC;
- organizar projetos complexos em módulos reutilizáveis.

Entre as linguagens mais conhecidas estão **Verilog** e **VHDL**.

---

## 2. Fluxo de desenvolvimento com HDL

O desenvolvimento de um circuito digital normalmente segue as etapas:

1. **Descrição RTL:** o circuito é escrito em HDL.
2. **Compilação e análise:** o código é verificado sintaticamente.
3. **Simulação:** o comportamento lógico é testado.
4. **Síntese:** a descrição RTL é convertida em uma *netlist* de portas e componentes.
5. **Otimização:** a ferramenta reduz área, atrasos ou consumo de recursos.
6. **Mapeamento e posicionamento:** os elementos são associados aos recursos físicos do dispositivo.
7. **Implementação física:** o projeto é gravado em um FPGA ou utilizado na fabricação de um circuito integrado.

A simulação pode ser repetida em diferentes etapas para confirmar se o circuito mantém o comportamento esperado.

---

## 3. Estrutura básica de um módulo Verilog

Em Verilog, um circuito é descrito dentro de um **módulo**.

```verilog
module nome_modulo (
    lista_de_portas
);

    // Declaração das portas

    // Sinais intermediários

    // Descrição do funcionamento

endmodule
```

Regras importantes:

- o módulo começa com `module` e termina com `endmodule`;
- Verilog diferencia letras maiúsculas de minúsculas;
- as palavras reservadas são escritas em letras minúsculas;
- a maioria das instruções termina com ponto e vírgula;
- comentários de uma linha utilizam `//`;
- comentários de várias linhas utilizam `/* ... */`.

---

## 4. Portas, fios e registradores

### 4.1 Portas

As portas representam a interface do módulo com outros circuitos.

| Tipo | Função |
|---|---|
| `input` | Entrada de dados |
| `output` | Saída de dados |
| `inout` | Porta bidirecional |

Exemplo com sinais de 1 bit:

```verilog
module half_adder (
    a,
    b,
    sum,
    carry
);

    input a, b;
    output sum, carry;

endmodule
```

Exemplo com barramentos:

```verilog
module circuito (
    a,
    b,
    cin,
    sum,
    cout
);

    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;

endmodule
```

A declaração `[3:0]` representa um vetor de 4 bits, do bit mais significativo ao menos significativo.

### 4.2 Fios

Sinais do tipo `wire` representam conexões entre componentes.

```verilog
wire ligacao;
wire [7:0] soma;
```

Outros tipos apresentados:

| Tipo | Significado |
|---|---|
| `wire` | Conexão lógica |
| `tri` | Conexão com possibilidade de alta impedância |
| `supply0` | Nível lógico baixo constante |
| `supply1` | Nível lógico alto constante |

Exemplo:

```verilog
tri barramento;
```

Um sinal `tri` pode assumir nível lógico `0`, `1` ou alta impedância, representada por `Z`.

### 4.3 Registradores e variáveis procedurais

Sinais atribuídos dentro de blocos `initial` ou `always` normalmente são declarados como `reg`.

```verilog
reg [7:0] resultado;
reg signed [7:0] valor_com_sinal;
integer contador;
```

Tipos citados no material:

| Tipo | Característica |
|---|---|
| `reg` | Variável sem sinal |
| `reg signed` | Variável com sinal |
| `integer` | Inteiro com sinal, normalmente de 32 bits |
| `real` | Número real, geralmente não sintetizável |
| `time` | Representação de tempo para simulação |
| `realtime` | Tempo com valor real |

> Em Verilog, o nome `reg` indica que o sinal recebe valores em um bloco procedural. Isso não significa, obrigatoriamente, que será criado um registrador físico.

---

## 5. Formas de descrição de circuitos

Um mesmo circuito pode ser representado de diferentes maneiras:

- **estrutural:** instancia diretamente portas lógicas;
- **fluxo de dados:** utiliza expressões e atribuições contínuas;
- **hierárquica:** conecta módulos menores para construir um circuito maior;
- **comportamental:** descreve o funcionamento por meio de blocos procedurais.

A escolha depende do nível de abstração desejado.

---

## 6. Descrição estrutural

Na descrição estrutural, o circuito é montado por meio de primitivas lógicas.

Primitivas comuns:

| Categoria | Primitivas |
|---|---|
| Múltiplas entradas | `and`, `or`, `nand`, `nor`, `xor`, `xnor` |
| Uma entrada | `not`, `buf` |
| Três estados | `bufif0`, `bufif1`, `notif0`, `notif1` |

Formato geral:

```verilog
primitiva nome_da_instancia (
    saida,
    entradas
);
```

Exemplo:

```verilog
and u0 (x, a, b);
not u1 (y, x);
```

### Exemplo: porta XOR estrutural

```verilog
module xor_estrutural (
    x,
    y,
    z
);

    input x, y;
    output z;

    wire nx, ny;
    wire p1, p2;

    not not0 (nx, x);
    not not1 (ny, y);

    and and0 (p1, x, ny);
    and and1 (p2, y, nx);

    or or0 (z, p1, p2);

endmodule
```

A expressão implementada é:

$$
z = x\overline{y} + \overline{x}y 
$$

---

## 7. Descrição por fluxo de dados

A descrição por fluxo de dados utiliza a palavra-chave `assign`.

```verilog
assign saida = expressao;
```

A atribuição é contínua: sempre que uma entrada da expressão muda, a saída é atualizada.

### 7.1 Constantes

Formato:

```text
<tamanho>'<base><valor>
```

Bases disponíveis:

| Símbolo | Base |
|---|---|
| `b` | Binária |
| `o` | Octal |
| `d` | Decimal |
| `h` | Hexadecimal |

Exemplos:

```verilog
assign x = -16'd6;
assign y = 8'hA0;
assign z = 4'b1001;
assign w = 6'o12;
```

### 7.2 Seleção de partes de vetores

```verilog
assign x = y[5:2];
assign z = y[1:0];
```

Também é possível selecionar apenas um bit:

```verilog
assign bit_zero = y[0];
```

### 7.3 Operadores lógicos bit a bit

| Operação | Operador |
|---|---|
| NOT | `~` |
| AND | `&` |
| OR | `|` |
| XOR | `^` |
| XNOR | `~^` ou `^~` |

Exemplo:

```verilog
assign y = a & b;
```

### 7.4 Operadores relacionais

| Operação | Operador |
|---|---|
| Maior que | `>` |
| Menor que | `<` |
| Igual | `==` |
| Maior ou igual | `>=` |
| Menor ou igual | `<=` |
| Diferente | `!=` |

Exemplo:

```verilog
assign diferentes = a != b;
```

O resultado de uma comparação é normalmente um valor de 1 bit.

### 7.5 Deslocamento

```verilog
assign deslocado_esquerda = a << 1;
assign deslocado_direita  = a >> 1;
```

### 7.6 Concatenação e replicação

Concatenação:

```verilog
assign x = {a, b};
```

Replicação:

```verilog
assign x = {3{b}};
```

Se `b = 2'b01`, então `{3{b}}` produz `6'b010101`.

### 7.7 Operadores aritméticos

| Operação | Operador |
|---|---|
| Soma | `+` |
| Subtração | `-` |
| Multiplicação | `*` |
| Divisão | `/` |
| Resto da divisão | `%` |

Exemplo:

```verilog
assign resultado = a + b;
```

### 7.8 Operador ternário

O operador ternário representa uma seleção condicional.

```verilog
assign x = condicao ? valor_verdadeiro : valor_falso;
```

Exemplo de multiplexador 2:1:

```verilog
module mux2x1 (
    a,
    b,
    sel,
    out
);

    input a, b, sel;
    output out;

    assign out = sel ? a : b;

endmodule
```

### Exemplo: porta XOR por fluxo de dados

```verilog
module xor_fluxo (
    x,
    y,
    z
);

    input x, y;
    output z;

    assign z = (x & ~y) | (~x & y);

endmodule
```

A mesma função também pode ser escrita como:

```verilog
assign z = x ^ y;
```

---

## 8. Descrição hierárquica

A descrição hierárquica permite utilizar um módulo dentro de outro.

Formato:

```verilog
nome_do_modulo nome_da_instancia (
    mapeamento_das_portas
);
```

### Mapeamento por posição

```verilog
half_adder ha1 (a1, b1, s1, c1);
```

Nesse formato, a ordem dos sinais deve ser exatamente a mesma da declaração do módulo.

### Mapeamento por nome

```verilog
half_adder ha1 (
    .a(a1),
    .b(b1),
    .sum(s1),
    .carry(c1)
);
```

O mapeamento por nome é mais legível e reduz erros de conexão.

Exemplo:

```verilog
module and2x1 (
    x,
    y,
    z
);

    input x, y;
    output z;

    assign z = x & y;

endmodule

module circuito (
    a,
    b,
    k,
    w
);

    input a, b;
    output k, w;

    and2x1 and1 (
        .x(a),
        .y(b),
        .z(k)
    );

    and2x1 and2 (
        .x(a),
        .y(b),
        .z(w)
    );

endmodule
```

---

## 9. Descrição comportamental

A descrição comportamental utiliza blocos procedurais, principalmente `initial` e `always`.

### 9.1 Bloco `initial`

O bloco `initial` é executado uma única vez no início da simulação.

```verilog
initial begin
    q = 1'b0;
end
```

É muito utilizado em bancos de teste. Dependendo da tecnologia e da ferramenta, nem toda construção `initial` é sintetizável.

### 9.2 Bloco `always`

O bloco `always` é executado sempre que ocorre um evento definido em sua lista de sensibilidade.

Circuito combinacional:

```verilog
always @(*) begin
    saida = expressao;
end
```

Circuito sequencial sensível à borda de subida:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

Circuito sensível à borda de descida:

```verilog
always @(negedge clk) begin
    q <= q + 1'b1;
end
```

### 9.3 Atribuição bloqueante e não bloqueante

- `=`: atribuição **bloqueante**, normalmente utilizada em lógica combinacional;
- `<=`: atribuição **não bloqueante**, normalmente utilizada em lógica sequencial.

Exemplo combinacional:

```verilog
always @(*) begin
    y = a & b;
end
```

Exemplo sequencial:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

### 9.4 Estrutura `if-else`

```verilog
module registrador_d (
    clk,
    rst,
    d,
    q
);

    input clk, rst, d;
    output reg q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule
```

Nesse exemplo, o sinal `rst` realiza uma reinicialização assíncrona.

### 9.5 Estrutura `for`

Laços `for` podem descrever operações repetitivas sobre vetores ou gerar lógica repetida.

```verilog
integer i;

always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin
        saida[i] = entrada[i];
    end
end
```

Durante a síntese, o laço é expandido em hardware. Ele não executa sequencialmente como um laço comum de software.

### 9.6 Estrutura `case`

A estrutura `case` seleciona uma operação com base em um identificador.

Exemplo de multiplexador 4:1:

```verilog
module mux4x1 (
    a,
    b,
    c,
    d,
    sel,
    out
);

    input a, b, c, d;
    input [1:0] sel;
    output reg out;

    always @(*) begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 1'b0;
        endcase
    end

endmodule
```

O `default` é recomendado para definir o comportamento nos casos não especificados.

---

## 10. Máquinas de estados finitos

Uma **Máquina de Estados Finitos (FSM)** representa sistemas cujo comportamento depende do estado atual e das entradas.

Uma FSM normalmente possui:

1. registrador do estado atual;
2. lógica de próximo estado;
3. lógica de saída.

Exemplo simplificado:

```verilog
module maquina_estados (
    clk,
    rst,
    x,
    y
);

    input clk, rst, x;
    output reg y;

    reg [1:0] estado_atual;
    reg [1:0] proximo_estado;

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst)
            estado_atual <= A;
        else
            estado_atual <= proximo_estado;
    end

    always @(*) begin
        case (estado_atual)
            A: begin
                y = 1'b0;
                if (x)
                    proximo_estado = A;
                else
                    proximo_estado = B;
            end

            B: begin
                y = 1'b1;
                if (x)
                    proximo_estado = C;
                else
                    proximo_estado = B;
            end

            C: begin
                y = 1'b1;
                proximo_estado = D;
            end

            D: begin
                y = 1'b0;
                proximo_estado = A;
            end

            default: begin
                y = 1'b0;
                proximo_estado = A;
            end
        endcase
    end

endmodule
```

O primeiro bloco `always` armazena o estado. O segundo calcula o próximo estado e a saída.

---

## 11. Descrição de memórias

Uma memória pode ser representada como um arranjo de registradores.

Formato geral:

```verilog
reg [M-1:0] nome_memoria [N-1:0];
```

Nesse formato:

- `M` representa a quantidade de bits por palavra;
- `N` representa a quantidade de posições.

Exemplo de memória com 16 palavras de 8 bits:

```verilog
module memoria (
    clk,
    w_data,
    w_addr,
    w_en,
    r_data,
    r_addr
);

    input clk;
    input [7:0] w_data;
    input [3:0] w_addr;
    input [3:0] r_addr;
    input w_en;

    output [7:0] r_data;

    reg [7:0] register_file [15:0];

    always @(posedge clk) begin
        if (w_en)
            register_file[w_addr] <= w_data;
    end

    assign r_data = register_file[r_addr];

endmodule
```

Características desse exemplo:

- a escrita é síncrona, pois ocorre na borda de subida do clock;
- a escrita somente ocorre quando `w_en = 1`;
- a leitura é assíncrona, pois utiliza uma atribuição contínua.
