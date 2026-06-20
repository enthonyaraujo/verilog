# Verilog 

Repositório destinado ao estudo e desenvolvimento de sistemas/circuitos digitais utilizando **Verilog HDL**.

## Conteúdo

- Códigos em Verilog;
- Simulações;
- Circuitos combinacionais;
- Circuitos sequenciais;
- Implementações em FPGA.

## Instalação das dependências

- [Guia de instalação](docs/installation-guide/README.md)

Definido para principais distros: 

- [Fedora](docs/installation-guide/fedora/fedora.md)
- [ArchLinux](docs/installation-guide/arch/arch.md)
- [Ubuntu](docs/installation-guide/ubuntu/ubuntu.md)
- [WSL](docs/installation-guide/wsl/wsl.md)

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

