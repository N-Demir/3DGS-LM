#!/bin/bash
set -e

# Check if data_folder and output_folder arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <data_folder> <output_folder>"
    echo "Example: $0 /nvs-bench/data/mipnerf360/bicycle /nvs-bench/methods/3dgs/mipnerf360/bicycle"
    exit 1
fi
data_folder=$1
output_folder=$2

######## START OF YOUR CODE ########
# 1) Train 
#   python train.py --data $data_folder --output $output_folder --eval
# 2) Render the test split
#   python render.py --data $data_folder/test --output $output_folder --eval
# 3) Move the renders into `$output_folder/test_renders`
#   mv $output_folder/test/ours_30000/renders $output_folder/test_renders

iterations=10

python train.py -s $data_folder -m $output_folder --eval --iterations $iterations \
    --image_subsample_size 25 \
    --image_subsample_n_iters 4 \
    --image_subsample_frame_selection_mode "strided" \
    --num_sgd_iterations_before_gn 20000 \
    --perc_images_in_line_search 0.3 \
    --pcg_rtol 5e-2 \
    --pcg_max_iter 8 \
    --min_trust_region_radius 1e-4 \
    --trust_region_radius 1e-3 \
    --max_trust_region_radius 1e-2

python render.py -s $data_folder -m $output_folder --eval --iteration $iterations

mv $output_folder/test/ours_$iterations/renders $output_folder/test_renders