# Guia de Instalação do ArchLinux

Dentro de **arch/** dê a permissão ao script e rode:

```bash
chmod +x archlinux.sh
./archlinux.sh
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
