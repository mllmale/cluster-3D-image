#!/bin/bash

mkdir -p ../data
cd ../data

# pode mudar a fonte

echo "Baixando ETH3D"
wget http://www.eth3d.net/data/datasets/mannequin_1.zip

unzip mannequin_1.zip
rm mannequin_1.zip

# Mover imagens para pasta padronizada
mkdir -p images
mv mannequin_1/rgb/* images/

echo "BAIXADO"
