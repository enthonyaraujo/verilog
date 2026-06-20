# FPGA no WSL 2

Guia completo para sintetizar projetos no Ubuntu/WSL 2 e gravar a FPGA Tang Nano 1K usando `usbipd-win` e `openFPGALoader`.


## 1. Como o acesso USB funciona no WSL

A porta USB pertence inicialmente ao Windows. O Ubuntu executado pelo WSL não enxerga a Tang Nano automaticamente.

O fluxo correto é:

1. conectar a Tang Nano ao Windows;
2. compartilhar o dispositivo com `usbipd bind`;
3. anexá-lo ao WSL com `usbipd attach`;
4. confirmar no Ubuntu com `lsusb`;
5. executar o `openFPGALoader` dentro do WSL.

Enquanto a placa estiver anexada ao WSL, ela não poderá ser usada simultaneamente por programas do Windows.

---

## 2. Verificar se a distribuição usa WSL 2

Execute no **PowerShell**:

```powershell
wsl --list --verbose
```

A distribuição Ubuntu deve aparecer com a versão `2`.

Exemplo:

```text
NAME      STATE      VERSION
Ubuntu    Running    2
```

Caso apareça a versão `1`, converta-a:

```powershell
wsl --set-version Ubuntu 2
```

Atualize o WSL:

```powershell
wsl --update
```

Depois reinicie o ambiente:

```powershell
wsl --shutdown
```

Abra novamente o Ubuntu.

---

## 3. Instalar o usbipd-win no Windows

Abra o **PowerShell como administrador** e execute:

```powershell
winget install --interactive --exact dorssel.usbipd-win
```

Verifique a instalação:

```powershell
usbipd --version
usbipd list
```

Se o comando ainda não for reconhecido, feche e abra o PowerShell novamente.

---

## 4 - Instalar o oss-cad-suite e openFPGALoader

Para instalar o oss-cad-suite e openFPGALoader siga os passo a passo de alguma distro linux citada anteriormente (provavelmente a que vem instalada por padrão no wsl é o [Ubuntu](https://ubuntu.com/wsl), mas você pode instalar o [ArchLinux](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL) e [Fedora](https://docs.fedoraproject.org/en-US/cloud/wsl/) também) 

- [Fedora](docs/installation-guide/fedora/fedora.md)
- [ArchLinux](docs/installation-guide/arch/arch.md)
- [Ubuntu](docs/installation-guide/ubuntu/ubuntu.md)

## 5. Identificar a Tang Nano no Windows

Conecte a Tang Nano ao computador.

Mantenha um terminal do Ubuntu aberto para que a máquina virtual do WSL permaneça ativa.

Abra o **PowerShell como administrador** e execute:

```powershell
usbipd list
```

Exemplo:

```text
BUSID  VID:PID    DEVICE                         STATE
1-1    0403:6010  USB Serial Converter A/B       Not shared
```

O valor da primeira coluna é o `BUSID`. Neste exemplo, ele é:

```text
1-1
```

Não digite literalmente `X-X`. Use o número mostrado pelo seu `usbipd list`.

Também não copie o texto do prompt:

```text
PS C:\WINDOWS\system32>
```

Digite somente o comando.

---

## 6. Compartilhar a placa com o WSL

### 6.1 Compartilhamento inicial — executado uma única vez

No **PowerShell como administrador**, substitua `1-1` pelo BUSID real:

```powershell
usbipd bind --busid 1-1
```

Confirme:

```powershell
usbipd list
```

O estado deve mudar de:

```text
Not shared
```

para:

```text
Shared
```

O `bind` é persistente e normalmente não precisa ser repetido após reinicializações.

### 6.2 Anexar a placa ao WSL

Depois do `bind`, o `attach` não precisa ser executado como administrador.

Com o Ubuntu/WSL aberto, execute em um **PowerShell normal**:

```powershell
usbipd attach --wsl --busid 1-1
```

Confirme:

```powershell
usbipd list
```

O estado deve aparecer como:

```text
Attached
```

Se o PowerShell mostrar `>>`, pressione `Ctrl+C`. Isso indica que ele está esperando a continuação de um comando incompleto. Digite cada comando separadamente.

---

## 7. Confirmar o dispositivo dentro do WSL

No terminal do **Ubuntu/WSL**, execute:

```bash
lsusb
```

A interface USB da Tang Nano deve aparecer na lista.

Depois teste o programador:

```bash
openFPGALoader -b tangnano1k --detect
```

Uma detecção correta deve informar um dispositivo Gowin, por exemplo:

```text
manufacturer Gowin
family GW1NZ
model GW1NZ-1
```

Caso a placa apareça em `lsusb`, mas o usuário comum não consiga acessá-la, teste:

```bash
sudo openFPGALoader -b tangnano1k --detect
```

Se funcionar apenas com `sudo`, o repasse USB está correto e o problema está nas permissões/regras udev.

---

## 8. Compilar o projeto

Entre na pasta do projeto:

```bash
cd ~/logicgates/logicgates
```

Limpe os arquivos anteriores:

```bash
make clean
```

O alvo `clean` do `Makefile` deve usar `rm -f`, para não falhar quando os arquivos não existirem:

```makefile
clean:
	rm -f *~ *.json *.fs
```

Compile:

```bash
make
```

Confirme que o arquivo final foi criado:

```bash
ls -lh nandgate.fs
```

Avisos como estes não impedem a geração do bitstream:

```text
Numpy is not available, performance will be degraded
Msgspec is not available, performance will be degraded
fastcrc is not available, performance will be degraded
```

A mensagem abaixo também não representa falha em um circuito puramente combinacional:

```text
No Fmax available; no interior timing paths found in design.
```

O resultado importante é:

```text
Program finished normally.
```

e a existência do arquivo `.fs`.

---

## 9. Gravar a Tang Nano 1K

### 9.1 Gravação temporária na SRAM

A configuração é perdida quando a placa é desligada:

```bash
openFPGALoader -b tangnano1k nandgate.fs
```

### 9.2 Gravação permanente na memória flash

A configuração permanece após desligar e ligar a placa:

```bash
openFPGALoader -b tangnano1k -f nandgate.fs
```

Antes da gravação, também pode ser feita uma detecção:

```bash
openFPGALoader -b tangnano1k --detect
```

---

## 10. Rotina diária recomendada

O `bind` normalmente é feito apenas na primeira configuração. Após reiniciar o computador, reiniciar o WSL ou desconectar a placa, normalmente basta executar novamente o `attach`.

### No Windows

1. Conecte a Tang Nano.
2. Abra o Ubuntu/WSL.
3. Em um PowerShell normal:

```powershell
usbipd list
usbipd attach --wsl --busid 1-1
```

### No Ubuntu/WSL

```bash
lsusb
cd ~/logicgates/logicgates
make
openFPGALoader -b tangnano1k nandgate.fs
```

Para gravar permanentemente:

```bash
openFPGALoader -b tangnano1k -f nandgate.fs
```

---

## 11. Desconectar a placa do WSL

Quando terminar, execute no **PowerShell**:

```powershell
usbipd detach --busid 1-1
```

Depois disso, a placa volta a ficar disponível para programas executados diretamente no Windows.

A placa também é desanexada quando:

- é desconectada fisicamente;
- o WSL é reiniciado;
- o Windows é reiniciado.

O estado continuará como `Shared`, portanto não é necessário repetir o `bind`.

---

## 12. Script para anexar a FPGA ao WSL

Crie no Windows um arquivo chamado:

```text
conectar-fpga-wsl.ps1
```

Conteúdo:

```powershell
param(
    [Parameter(Mandatory = $true)]
    [string]$BusId
)

$ErrorActionPreference = "Stop"

Write-Host "Iniciando o WSL..."
wsl.exe -e sh -lc "true"

Write-Host "Anexando o dispositivo USB $BusId ao WSL..."
usbipd attach --wsl --busid $BusId

Write-Host ""
Write-Host "Estado atual:"
usbipd list

Write-Host ""
Write-Host "Dispositivos USB visíveis no WSL:"
wsl.exe -e bash -lc "lsusb"
```

Execute em um PowerShell normal:

```powershell
powershell -ExecutionPolicy Bypass -File .\conectar-fpga-wsl.ps1 -BusId 1-1
```

O script considera que o dispositivo já passou pelo `usbipd bind`.

---

## 13. Script para preparar o compartilhamento inicial

Crie um arquivo chamado:

```text
preparar-fpga-wsl.ps1
```

Conteúdo:

```powershell
param(
    [Parameter(Mandatory = $true)]
    [string]$BusId
)

$ErrorActionPreference = "Stop"

usbipd bind --busid $BusId
usbipd list
```

Execute o PowerShell como administrador:

```powershell
powershell -ExecutionPolicy Bypass -File .\preparar-fpga-wsl.ps1 -BusId 1-1
```

Este script normalmente precisa ser executado apenas uma vez por dispositivo.

---

## 14. Erros frequentes

### `unable to open ftdi device: -3 (device not found)`

O WSL não está enxergando a interface USB.

Verifique no Windows:

```powershell
usbipd list
```

O estado precisa ser:

```text
Attached
```

Verifique no WSL:

```bash
lsusb
```

Se a placa não aparecer, repita:

```powershell
usbipd attach --wsl --busid 1-1
```

---

### `Device is not shared`

O `attach` foi executado antes do `bind`.

Abra o PowerShell como administrador:

```powershell
usbipd bind --busid 1-1
```

Depois, em PowerShell normal:

```powershell
usbipd attach --wsl --busid 1-1
```

A ordem correta é sempre:

```text
bind -> attach -> lsusb -> openFPGALoader
```

---

### `unable to open ftdi device: -4 (usb_open() failed)`

A interface foi encontrada, mas não pôde ser aberta.

No WSL, teste:

```bash
sudo openFPGALoader -b tangnano1k --detect
```

Se funcionar com `sudo`, reinstale/recarregue as regras udev e confirme o grupo:

```bash
sudo cp ~/tools/openFPGALoader/99-openfpgaloader.rules \
    /etc/udev/rules.d/99-openfpgaloader.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -aG plugdev "$USER"
```

Depois:

```powershell
wsl --shutdown
```

Abra novamente o Ubuntu e anexe a placa outra vez.

---

### `openFPGALoader: command not found`

Confira o executável:

```bash
which openFPGALoader
```

Se estiver usando o OSS CAD Suite:

```bash
export PATH="$HOME/tools/oss-cad-suite/bin:$PATH"
```

Para manter permanentemente:

```bash
echo 'export PATH="$HOME/tools/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Se a instalação manual foi usada:

```bash
sudo ldconfig
hash -r
```

---

### `usbipd: command not found` no PowerShell

Feche e abra o PowerShell depois da instalação.

Verifique:

```powershell
Get-Command usbipd
```

Se necessário, execute diretamente:

```powershell
& "C:\Program Files\usbipd-win\usbipd.exe" list
```

---

### `Cannot parse argument 'X-X'`

`X-X` é apenas um exemplo. Descubra o BUSID real:

```powershell
usbipd list
```

Depois use o valor da primeira coluna:

```powershell
usbipd bind --busid 1-1
usbipd attach --wsl --busid 1-1
```

---

### O PowerShell mostra `>>`

O PowerShell está esperando a continuação do comando.

Pressione:

```text
Ctrl+C
```

Depois execute os comandos um por vez. Não copie o texto do prompt:

```text
PS C:\WINDOWS\system32>
```

---

### `make: Nothing to be done for 'all'`

Os arquivos de saída já estão atualizados.

Force uma nova compilação:

```bash
make clean
make
```

Ou:

```bash
rm -f *~ *.json *.fs
make
```

---

## 15. Verificação completa

### PowerShell

```powershell
wsl --list --verbose
usbipd --version
usbipd list
```

Estado esperado da placa:

```text
Attached
```

### Ubuntu/WSL

```bash
lsusb
yosys -V
nextpnr-himbaechel --version
gowin_pack --help
openFPGALoader --version
openFPGALoader -b tangnano1k --detect
```

### Projeto

```bash
cd ~/logicgates/logicgates
make clean
make
ls -lh nandgate.fs
openFPGALoader -b tangnano1k nandgate.fs
```

---

## 16. Resumo dos comandos principais

### Primeira configuração

PowerShell como administrador:

```powershell
usbipd list
usbipd bind --busid 1-1
```

PowerShell normal:

```powershell
usbipd attach --wsl --busid 1-1
```

Ubuntu/WSL:

```bash
lsusb
openFPGALoader -b tangnano1k --detect
```

### Uso diário

PowerShell:

```powershell
usbipd attach --wsl --busid 1-1
```

Ubuntu/WSL:

```bash
cd ~/logicgates/logicgates
make
openFPGALoader -b tangnano1k nandgate.fs
```

### Gravação permanente

```bash
openFPGALoader -b tangnano1k -f nandgate.fs
```

### Encerrar

PowerShell:

```powershell
usbipd detach --busid 1-1
```
