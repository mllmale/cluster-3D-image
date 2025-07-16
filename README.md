# 📷 Pipeline COLMAP para Reconstrução 3D

Este repositório contém scripts para realizar **reconstrução 3D** usando o [COLMAP](https://colmap.github.io/) localmente ou em ambiente de cluster. O pipeline inclui:

- Extração de features
- Emparelhamento de imagens
- Reconstrução esparsa (Structure-from-Motion)
- Conversão para formato compatível com MVS (Multi-View Stereo)
- Reconstrução densa (opcional)
- Suporte a execução em cluster via SLURM

---

## ✅ Requisitos

- COLMAP compilado e instalado localmente (modo GUI ou headless)
- Shell Bash (Linux)
- Dependências do COLMAP instaladas:
  - `cmake`, `boost`, `eigen`, `Qt5`, `OpenCV`
  - **CUDA (opcional)** para reconstrução densa
 
## 🛠️ Passo 1: Instalação do COLMAP

### 🔹 Instalar via código-fonte (Linux)

```bash
git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
cmake ..
make -j$(nproc)

## 🚀 Passo 2: Executar Reconstrução Local
Use o script run_colmap_local.sh para rodar o pipeline completo de reconstrução esparsa:

```bash
chmod +x run_colmap_local.sh
env DISPLAY=:0 QT_QPA_PLATFORM=offscreen ./run_colmap_local.sh
```
## Passo 3 (Opcional): Reconstrução Densa
Se sua máquina tiver uma GPU com CUDA, você pode executar o script run_colmap_dense.sh para gerar a reconstrução densa (nuvem de pontos detalhada):

```bash
chmod +x run_colmap_dense.sh
env DISPLAY=:0 QT_QPA_PLATFORM=offscreen ./run_colmap_dense.sh
```

## 🧬 Passo 4 (Opcional): Execução em Cluster (via SLURM)
Para uso em clusters com SLURM, execute:
```bash
chmod +x run_colmap_slurm.sh
env DISPLAY=:0 QT_QPA_PLATFORM=offscreen ./run_colmap_slurm.sh
```
