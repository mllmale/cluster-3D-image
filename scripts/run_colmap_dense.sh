#!/bin/bash

set -e

# NECESSSARIO DE CUDA, ENT EU AINDA NÃO TESTEI

COLMAP_BIN="$HOME/Documentos/processamento/colmap/build/src/colmap/exe/colmap"
WORKSPACE="$DENSE_DIR"
OUTPUT_PLY="$DENSE_DIR/fused.ply"

mkdir -p "$WORKSPACE"

echo "Iniciando reconstrução densa..."

# 1. Patch Match Stereo
xvfb-run "$COLMAP_BIN" patch_match_stereo \
    --workspace_path "$WORKSPACE" \
    --PatchMatchStereo.geom_consistency true

# 2. Stereo Fusion
xvfb-run "$COLMAP_BIN" stereo_fusion \
    --workspace_path "$WORKSPACE" \
    --input_type geometric \
    --output_path "$OUTPUT_PLY"

echo "Arquivo gerado: $OUTPUT_PLY"
