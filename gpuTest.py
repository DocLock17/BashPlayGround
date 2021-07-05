# This Handy Bit of code will tell you a bit about your current Tensorflow and GPU configuration

import os
import tensorflow as tf
#import tensorflow_hub as hub
from tensorflow.python.client import device_lib
print("TF version:", tf.__version__)
#print("Hub version:", hub.__version__)
print("")
print("GPU is", "available" if tf.config.list_physical_devices('GPU') else "NOT AVAILABLE")
print("")
print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices('GPU')))
print("")
print(device_lib.list_local_devices())
