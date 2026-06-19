#!/usr/bin/env bash

set -e

if [ "$EUID" -eq 0 ]; then
    echo "Execute este script sem sudo:"
    echo "  ./fedora.sh"
    exit 1
fi

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

echo "Baixando $ARCHIVE..."

wget -O "$ARCHIVE" \
  "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/$RELEASE/$ARCHIVE"

rm -rf "$HOME/Downloads/oss-cad-suite"

echo "Extraindo o OSS CAD Suite..."

tar -xzf "$ARCHIVE"

if [ -d "/opt/oss-cad-suite" ]; then
    echo "Removendo instalação anterior..."
    sudo rm -rf /opt/oss-cad-suite
fi

echo "Movendo o OSS CAD Suite para /opt..."

sudo mv oss-cad-suite /opt/

echo "Configurando o PATH..."

if ! grep -q '/opt/oss-cad-suite/bin' "$HOME/.bashrc"; then
    echo 'export PATH="/opt/oss-cad-suite/bin:$PATH"' >> "$HOME/.bashrc"
fi

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

echo "Adicionando o usuário $USER ao grupo dialout..."

sudo usermod -aG dialout "$USER"

echo "Recarregando as regras udev..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Permissões USB configuradas."

echo
echo "Instalação concluída!"
echo
echo "Execute no terminal atual:"
echo "  source ~/.bashrc"
echo
echo "Depois:"
echo "  1. Encerre e entre novamente na sessão."
echo "  2. Desconecte e conecte novamente a placa FPGA."
echo
echo "Após entrar novamente, teste com:"
echo "  id"
echo "  lsusb"
echo "  openFPGALoader --detect"
