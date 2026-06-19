# Verilog 

Repositório destinado ao estudo e desenvolvimento de sistemas/circuitos digitais utilizando **Verilog HDL**.

## Conteúdo

- Códigos em Verilog;
- Simulações;
- Circuitos combinacionais;
- Circuitos sequenciais;
- Implementações em FPGA.

## Instalação

- [Guia de instalação](installation-guide/README.md)

## Estrutura do repositório

```text
verilog/
├── assets/
├── digital-circuits
│   ├── practice-00/
│   └── practice-01/
├── docs/
│   ├── installation-guide/
│   └── notes/
├── LICENSE
└── README.md
```

## Dependências

| Ferramenta | Função |
|---|---|
| **[oss-cad-suite](https://github.com/yosyshq/oss-cad-suite-build)** | Síntese, posicionamento e roteamento, além da geração do bitstream usando Yosys e nextpnr |
| **[openFPGALoader](https://github.com/trabucayre/openFPGALoader)** | Programação da FPGA via USB/JTAG |
| **Drivers USB** | Comunicação com a placa FPGA |

