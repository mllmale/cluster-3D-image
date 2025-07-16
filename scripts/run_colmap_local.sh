#!/bin/bash

set -e  

COLMAP_BIN="$HOME/Documentos/processamento/colmap/build/src/colmap/exe/colmap"

# Caminhos
DATASET_DIR="../data/images"
WORKSPACE_DIR="../data/sparse_model"
DENSE_DIR="../data/dense_model"
DB="../data/database.db"

echo "Iniciando reconstrução local COLMAP..."

# 1. Limpa arquivos antigos
rm -f "$DB"
rm -rf "$WORKSPACE_DIR"
rm -rf "$DENSE_DIR"
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$DENSE_DIR"

START_TIME=$(date +%s)

# 2. Extração de features
"$COLMAP_BIN" feature_extractor \
    --database_path "$DB" \
    --image_path "$DATASET_DIR" \
    --ImageReader.single_camera 1

#exhaustive_matcher é mais lento
# 3. Emparelhamento de features
"$COLMAP_BIN" sequential_matcher \
    --database_path "$DB"

# 4. Reconstrução incremental
"$COLMAP_BIN" mapper \
    --database_path "$DB" \
    --image_path "$DATASET_DIR" \
    --output_path "$WORKSPACE_DIR"

# 5. Converter para formato compatível com MVS
MODEL_PATH=$(ls -d "$WORKSPACE_DIR"/* | head -n 1)

"$COLMAP_BIN" model_converter \
    --input_path "$MODEL_PATH" \
    --output_path "$DENSE_DIR" \
    --output_type TXT

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "Tempo total gasto: $ELAPSED segundos"


# https://colmap.github.io/cli.html

#  env   DISPLAY=:0   QT_QPA_PLATFORM=offscreen   ./run_colmap_local.sh