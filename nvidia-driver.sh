#!/bin/bash

# ==============================================================================
# Script de Instalação de Driver NVIDIA e CUDA Toolkit para Nós de Cluster Slurm
#
# Distribuição Alvo: Ubuntu 22.04 LTS
#
# IMPORTANTE:
# 1. Execute este script como root ou com privilégios de sudo.
# 2. Execute-o em cada nó de computação que possui uma GPU.
# 3. Garanta que o acesso à internet esteja disponível para baixar os pacotes.
#
# ==============================================================================

# -- Configuração --
# Pega a versão do Ubuntu
OS_RELEASE=$(lsb_release -rs)
# Arquitetura do sistema
ARCH=$(uname -m)
# Versão do CUDA. Verifique as versões mais recentes no site da NVIDIA se necessário.
CUDA_VERSION="12.2"

set -e  # Sai imediatamente se um comando falhar
set -x  # Exibe os comandos sendo executados

echo "### PASSO 1: Atualizar o sistema e instalar pré-requisitos ###"
apt-get update
apt-get install -y build-essential linux-headers-$(uname -r)

echo "### PASSO 2: Remover instalações antigas da NVIDIA (se existirem) ###"
# Isso garante um ambiente limpo.
apt-get purge -y '*nvidia*' || true
apt-get autoremove -y || true

echo "### PASSO 3: Adicionar o repositório CUDA da NVIDIA ###"
# Este é o método recomendado pela NVIDIA para instalação via apt.
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/${ARCH}/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update

echo "### PASSO 4: Instalar o Driver NVIDIA e o CUDA Toolkit ###"
# A instalação do metapacote 'cuda' garante que o driver compatível e o toolkit
# sejam instalados juntos. O 'cuda-drivers' garante a instalação do driver mais recente do repo.
apt-get -y install cuda-toolkit-${CUDA_VERSION/./-} cuda-drivers

# Opcional: Se você quiser apenas o driver e um CUDA Toolkit mínimo (sem samples, etc.)
# apt-get -y install cuda-drivers cuda-toolkit-${CUDA_VERSION/./-}-base

echo "### PASSO 5: Configurar o ambiente (apenas informativo) ###"
# O caminho do CUDA será /usr/local/cuda-12.2
# É uma BOA PRÁTICA NÃO definir PATH e LD_LIBRARY_PATH globalmente no /etc/profile.
# Em um ambiente de cluster, isso deve ser gerenciado por meio de "Environment Modules".
# O symlink /usr/local/cuda será criado apontando para a versão instalada.
echo "O CUDA foi instalado em /usr/local/cuda-${CUDA_VERSION}"
echo "Um link simbólico foi criado em /usr/local/cuda"

# Exportando o caminho para a sessão atual para verificação
export PATH=/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

echo "### PASSO 6: Verificação Pós-Instalação ###"
echo "--- Verificando nvidia-smi (Driver) ---"
nvidia-smi

echo "--- Verificando nvcc (CUDA Compiler) ---"
nvcc --version

echo "### INSTALAÇÃO CONCLUÍDA ###"
echo "-> Lembre-se de REINICIAR o nó para que o driver da NVIDIA seja carregado corretamente."
echo "-> A seguir, configure o gres.conf e slurm.conf no nó mestre do Slurm."

# Comando final para reiniciar (opcional, pode ser feito manualmente)
# echo "Reiniciando em 30 segundos..."
# sleep 30
# reboot
