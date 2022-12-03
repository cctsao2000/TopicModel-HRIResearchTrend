library(reticulate)
# We can set python path for TF1
path_to_python <- "/opt/miniconda3/envs/TF1/bin/python"
use_python(path_to_python)
use_condaenv(condaenv = 'TF1', required = TRUE)
conda_python(envname = 'TF1', conda = "auto")
library(keras)
library(tensorflow)
# We can use both one or more GPU card by setting card numbers, e.g. #0 and #1 :
# Sys.setenv(CUDA_VISIBLE_DEVICES = “0, 1”)
# use card #0 only
Sys.setenv(CUDA_VISIBLE_DEVICES = "0")
# Allow using more memory (allow_growth = T) up to 70% of GPU memory usage
gpu_options = tf$GPUOptions(per_process_gpu_memory_fraction = 0.1, allow_growth = T)
sess = tf$Session(config = tf$ConfigProto(gpu_options = gpu_options))
# Set Keras backend = Tensorflow
k_set_session(sess)
