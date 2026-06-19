#!/usr/bin/env bash

set -e

echo "Configurando FPGA no Fedora..."

echo "Atualizando o Fedora..."
sudo dnf update -y
echo "Sistema atualizado!"

echo "Baixando as dependências..."
sudo dnf install -y \
  git \
  wget \
  tar \
  gzip \
  xz \
  unzip \
  make \
  cmake \
  gcc \
  gcc-c++ \
  python3 \
  python3-pip \
  libusb1 \
  libusb1-devel \
  libftdi \
  libftdi-devel \
  hidapi \
  hidapi-devel \
  systemd-udev \
  systemd-devel \
  zlib-devel \
  pkgconf-pkg-config \
  usbutils \
  pciutils

echo "Dependências instaladas."

echo "Instalando o OSS CAD Suite..."

RELEASE="2026-06-19"
ARCHIVE="oss-cad-suite-linux-x64-20260619.tgz"

mkdir -p "$HOME/Downloads"
cd "$HOME/Downloads"

wget -O "$ARCHIVE" \
  "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/$RELEASE/$ARCHIVE"

# Evita misturar a nova extração com uma pasta antiga.
rm -rf "$HOME/Downloads/oss-cad-suite"

tar -xzf "$ARCHIVE"

if [ -d "/opt/oss-cad-suite" ]; then
    echo "Removendo instalação anterior..."
    sudo rm -rf /opt/oss-cad-suite
fi

sudo mv oss-cad-suite /opt/

if ! grep -q '/opt/oss-cad-suite/bin' "$HOME/.bashrc"; then
    echo 'export PATH="/opt/oss-cad-suite/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Disponibiliza as ferramentas durante a execução atual do script.
export PATH="/opt/oss-cad-suite/bin:$PATH"

echo "Testando instalação..."

yosys -V
nextpnr-himbaechel --version
openFPGALoader --version

echo "Configurando permissões USB para o openFPGALoader..."

wget \
  https://raw.githubusercontent.com/trabucayre/openFPGALoader/master/70-openfpgaloader.rules \
  -O /tmp/70-openfpgaloader.rules

sudo install -m 644 \
  /tmp/70-openfpgaloader.rules \
  /etc/udev/rules.d/70-openfpgaloader.rules

sudo usermod -aG dialout "$USER"

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Permissões USB configuradas."

echo
echo "Instalação concluída!"
echo "Execute no terminal atual: source ~/.bashrc"
echo "Depois, encerre e entre novamente na sessão."
echo "Desconecte e conecte novamente a placa FPGA."
echo
echo "Após entrar novamente, teste com:"
echo "  id"
echo "  lsusb"
echo "  openFPGALoader --detect"

