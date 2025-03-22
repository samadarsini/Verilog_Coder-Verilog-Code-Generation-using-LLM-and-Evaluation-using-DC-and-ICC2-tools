# Verilog_Coder: Verilog Code Generation using LLM and Evaluation using DC and ICC2 Tools
## 1. Overview
This project implements Verilog_Coder, a Large Language Model (LLM) designed to generate Verilog code from natural language descriptions. In addition to Verilog_Coder, we utilized GPT-3.5 and GPT-4 to generate alternative code versions for the same instructions. These codes were evaluated based on area and power metrics using Synopsys Design Compiler (DC) and IC Compiler II (ICC2) tools. Verilog_Coder was benchmarked against the Verilog_eval machine part and RTLLM V1.1. We also selected certain generated codes from RTLLM V1.1, developed corresponding testbenches, simulated them, and observed their functionality.

Note: This project was inspired by and utilizes the RTL-Coder model, an open-source LLM solution for RTL code generation. More details can be found in the RTL-Coder GitHub repository. [RTL-Coder](https://github.com/hkust-zhiyao/RTL-Coder)


## 2. Workflow Overview
The project was conducted on the Google Colab Pro platform with GPU support, as running it on local systems with only a CPU is impractical. A system with a compatible graphics card and the latest version of CUDA installed is required.

Important: Ensure that the installed version of PyTorch matches the installed CUDA version.

## 3. Training
The instruction and reference code dataset is sourced from the "Resyn-27k.json" file included in the provided zip file. Begin by installing all libraries listed in the requirements.txt file. The training process is managed by the training.py script.

To execute this script, run the following command in the terminal, specifying the data path and model path. The data path refers to the attached dataset, and the model path is the pre-trained model used as a foundation for training Verilog_Coder. In this case, we used "ishorn5/RTLCoder-Deepseek-v1.1". Specify the desired output path as well.

<pre>
torchrun --nproc_per_node=4 training.py \
    --model_name_or_path <model_path> \
    --data_path <data_path> \
    --fp16 True \
    --output_dir <output_path> \
    --num_train_epochs 3 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 2 \
    --gradient_accumulation_steps 64 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 50 \
    --save_total_limit 10 \
    --learning_rate 1e-5 \
    --weight_decay 0. \
    --logging_steps 1 \
    --tf32 False \
    --gradient_checkpointing True \
    --deepspeed ds_stage_2.json \
    --model_max_length 2048
</pre>
## 4. Testing Verilog_Coder on Verilog-eval
First, clone the verilog-eval benchmark using the following command:

<pre>git clone https://github.com/NVlabs/verilog-eval.git</pre>

After cloning, run the following script to evaluate the model on the evalmachine benchmark:

<pre>python verilogeval_testing.py --model <your_model_path> --n 20 --temperature=0.2 --gpu_name 0 --output_dir <your_result_directory> --output_file <your_result_file> --bench_type Machine</pre>
Replace <your_model_path>, <your_result_directory>, and <your_result_file> with your specific paths and filenames. The output file for this benchmark is provided as rtlcoder_temp0.2_evalmachine.json.

## 5. Testing on RTLLM
Next, clone the RTLLM benchmark using the following command:

<pre>git clone https://github.com/hkust-zhiyao/RTLLM.git</pre>
After cloning, run the following script to perform inference with the model:

<pre>python rtllm_testing.py --model <your_model_path> --n 5 --temperature=0.5 --gpu_name 0 --output_dir <your_result_directory></pre>
As before, specify the appropriate paths. The RTL code files generated for the descriptions in rtllm-1.1.json are included in the attached zip file under the "rtllm_generated_codes" folder.

To experiment with different prompts for generating various Verilog codes, you can use the following Python snippet:

<pre>from ctransformers import AutoModelForCausalLM
model_path = <model_path>
llm = AutoModelForCausalLM.from_pretrained(
    model_path,
    model_type="mistral",
    gpu_layers=0,
    max_new_tokens=2000,
    context_length=6048,
    temperature=0.5,
    top_p=0.95,
)
prompt = "Please act as a professional Verilog designer and provide a half_adder including clock."
print(llm(prompt))</pre>

## 6. Evaluation using DC and ICC2 Tools
By providing different prompts to the model, we generated Verilog codes using GPT-3.5, GPT-4, and Verilog_Coder. These files were synthesized using DC and ICC2 tools to assess area and power metrics. All synthesized files are organized into separate folders within the "evaluation_DC_ICC2" directory in the attached zip file. The TCL files for DC and ICC2 synthesis are also included in this folder. Modify these TCL files as needed, adjusting paths and clock periods.

## 7. Evaluation using Synopsys VCS Simulator
We selected certain codes generated from the RTLLM benchmark, developed corresponding testbenches, and simulated these designs using the Synopsys VCS simulator available on the open-source EDA Playground platform. The resulting waveforms were analyzed to observe functionality. All designs, testbenches, and waveforms are included in the "evaluation_VCS" folder.

## References:
RTL-Coder: A new LLM solution for RTL code generation, achieving state-of-the-art performance in non-commercial solutions and outperforming GPT-3.5. More details can be found in the RTL-Coder GitHub repository. [RTL-Coder](https://github.com/hkust-zhiyao/RTL-Coder)


