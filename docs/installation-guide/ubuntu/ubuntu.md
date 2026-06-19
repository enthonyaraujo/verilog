# Guia de Instalação do Ubuntu

Dentro de **ubuntu/** dê a permissão ao script e rode:

```bash
chmod +x ubuntu.sh
./ubuntu.sh
````

## Importante

Após terminar a instalação execute no terminal atual:
```bash
source ~/.bashrc
```
Depois, encerre e entre novamente na sessão.
Desconecte e conecte novamente a placa FPGA.

Após entrar novamente, teste com:
```bash
id
lsusb
openFPGALoader --detect
````
ou
```bash
yosys -V
nextpnr-himbaechel --version
openFPGALoader --version
```
