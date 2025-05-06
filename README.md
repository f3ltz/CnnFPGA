# CNN-Verilog: CIFAR-10 Image Classification using Verilog

## Introduction
### Technical Approach
The project consists of four key phases:

1. **Requirement Definition** – Setting project goals: simulating a multi-object classification task with color images.
2. **Data Preparation** – Selecting the dataset, preprocessing (cleaning, quantization, etc.).
3. **Model Construction** – Designing and training a neural network in PyTorch, optimizing via distillation, pruning, and weight quantization.
4. **Verilog Implementation** – Translating the model into Verilog 


## Network Architecture
The model processes CIFAR-10 images through multiple operations to classify them.

### Features
- Adapted the project for CIFAR-10 
- Designed and trained a new PyTorch model with distillation.
- Removed the third convolution layer.
- Added an extra fully connected layer.
- Replaced Tanh with ReLU in the convolution layer.
- Used MaxPooling instead of AvgPooling.
- Fixed errors in the original code (reset naming, bit-width mismatches, etc.).
- Adjusted input/output dimensions in the fully connected layer.
- Wrote and tested the convolution layer Testbench.
- Developed a 16-bit to 32-bit converter with a testbench.
- Merged convolution and fully connected layers into one module.
- Provided PyTorch training scripts, model weights, and quantization code.

### 1. integrationConv (Convolution Module)
Handles convolution, activation, and pooling.
- **Inputs**: Image data, convolution filters.
- **Outputs**: Feature maps after two convolution + max-pooling layers.

### 2. ReLU (Activation Function Module)
Implements the ReLU activation function.

### 3. MaxPoolIntegration (Max-Pooling Module)
Performs max-pooling operations.

### 4. ANNtop (Fully Connected Layer Module)
Implements fully connected layers with activation.

### 5. Convert16to32 (Precision Conversion Module)
Converts 16-bit floating-point numbers to 32-bit floating-point format.

### 6. CNNtop (Complete Network Module)
Implements the entire CNNtop model with two convolution and three fully connected layers.

## Requirements
- Windows
- Python 3.7+
- PyTorch
- Vivado

### 2. Train the Model
Pretrained models are available.
   sh
cd ./cifar_source_torch
python main.py
   

### 3. Quantization
Move trained model ( .pt ) to the quantization folder.
Modify weight paths in  ANNfull.v  and  Lenet_tb.v .
   sh
python quantification_para.py  # Weight Quantization  
python quantification_img.py   # Image Quantization  
   

### 4. Run Simulation in Vivado
Open  CNN-FPGA-Vivado , run  tb  simulation in Vivado to observe results.

## File Structure
### 1. cifar_source_torch (PyTorch Training Code)
-  distill.py  – Distillation script
-  distilled_lenet5_best.pt  – Pretrained model
-  main.py  – Main script
-  models.py  – Model definition
-  save_params.py  – Saves parameters
-  test.py  – Testing script

### 2. CNN-Vivado
Contains Verilog code, testbenches, and full Vivado project.

### 3. quantification (Quantization Code)
-  cifar-10-python  – Dataset
-  quantification_img.py  – Image quantization
-  quantification_para.py  – Model weight quantization

### 4. weight (Model Weights)
-  classifier.txt  – Fully connected layer 3 weights
-  FullyConnected1.txt  – Fully connected layer 1 weights
-  FullyConnected2.txt  – Fully connected layer 2 weights
-  Layer1.txt  – Convolution layer 1 weights
-  Layer2.txt  – Convolution layer 2 weights
