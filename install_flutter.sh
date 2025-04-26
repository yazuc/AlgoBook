#!/bin/bash

# === CONFIGURAÇÕES ===
FLUTTER_DIR="$HOME/flutter"
BASHRC="$HOME/.bashrc"  # Altere para .zshrc se você usa Zsh

# === DEPENDÊNCIAS ===
echo "▶ Instalando dependências básicas..."
sudo pacman -S --needed base-devel git curl unzip xz zip libglvnd -y

# === REMOVER RESÍDUOS DE INSTALAÇÕES ANTERIORES ===
echo "▶ Limpando Flutter antigo (se existir)..."
rm -rf "$FLUTTER_DIR"

# === CLONAR FLUTTER ===
echo "▶ Clonando Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"

# === ADICIONAR AO PATH ===
if ! grep -q "$FLUTTER_DIR/bin" "$BASHRC"; then
  echo "▶ Adicionando Flutter ao PATH..."
  echo -e "\n# Flutter SDK\nexport PATH=\"\$PATH:$FLUTTER_DIR/bin\"" >> "$BASHRC"
  source "$BASHRC"
else
  echo "✔ Flutter já está no PATH."
fi

# === VERIFICAR INSTALAÇÃO ===
echo "▶ Rodando flutter doctor..."
"$FLUTTER_DIR/bin/flutter" doctor

echo -e "\n✅ Instalação completa! Reinicie o terminal ou execute: source $BASHRC"
