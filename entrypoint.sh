#!/bin/bash
. /opt/conda/etc/profile.d/conda.sh
conda activate fastai-cpu

cd /notebooks
jupyter notebook --ip=0.0.0.0 --no-browser --NotebookApp.token='' # --debug > /notebooks/jup_debug.log 2>&1
