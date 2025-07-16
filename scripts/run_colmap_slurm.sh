#!/bin/bash
#SBATCH --job-name=sfm_cluster
#SBATCH --output=../logs/slurm-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00

set -e  # para abortar se algum comando falhar

# EU NÃO TESTEI ESSA BUDEGA

COLMAP_BIN="$HOME/Documentos/processamento/colmap/build/src/colmap/exe/colmap"  
# talvez o caminha seja outro

unset DISPLAY
unset QT_QPA_PLATFORM
unset XDG_RUNTIME_DIR

# Diretórios
DATASET_DIR=../data/images
WORKSPACE=../outputs/cluster
DB=$WORKSPACE/database.db
SPARSE_DIR=$WORKSPACE/sparse

mkdir -p "$WORKSPACE"
mkdir -p "$SPARSE_DIR"

START=$(date +%s)

# 1. Extração de features
"$COLMAP_BIN" feature_extractor \
    --database_path "$DB" \
    --image_path "$DATASET_DIR" \
    --ImageReader.single_camera 1

# 2. Emparelhamento exaustivo
"$COLMAP_BIN" exhaustive_matcher \
    --database_path "$DB"

# 3. Reconstrução esparsa
"$COLMAP_BIN" mapper \
    --database_path "$DB" \
    --image_path "$DATASET_DIR" \
    --output_path "$SPARSE_DIR"

END=$(date +%s)
echo "Tempo total cluster: $(($END - $START)) segundos"

#  env   DISPLAY=:0   QT_QPA_PLATFORM=offscreen   ./run_colmap_slurm.sh
