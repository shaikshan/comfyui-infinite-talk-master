# ===============================
# CUDA 12.4 + Ubuntu 22.04 (VALID BASE IMAGE)
# ===============================
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV HF_HOME=/workspace/.cache/huggingface

# ===============================
# System dependencies
# ===============================  
RUN apt-get update && apt-get install -y \
    git curl wget ffmpeg unzip ca-certificates \
    build-essential \
    python3.11 python3.11-venv python3.11-dev \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# ===============================
# Python default
# ===============================
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

WORKDIR /workspace

# ===============================
# Virtual environment
# ===============================
RUN python -m venv /workspace/venv
ENV PATH="/workspace/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel

# ===============================
# PyTorch (CUDA 12.4 via cu12 wheels)
# ===============================
RUN pip install \
    torch==2.4.1+cu124 \
    torchvision==0.19.1+cu124 \
    torchaudio==2.4.1+cu124 \
    --index-url https://download.pytorch.org/whl/cu124


# ===============================
# Python dependencies (FULL for ComfyUI + InfiniteTalk)
# ===============================
RUN pip install \
    numpy scipy einops tqdm psutil pillow pyyaml \
    aiohttp yarl safetensors \
    transformers tokenizers sentencepiece accelerate \
    av sqlalchemy alembic GitPython torchsde pyloudnorm

# ===============================
# code-server (PINNED, stable)
# ===============================
RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.95.1/code-server_4.95.1_amd64.deb \
 && dpkg -i code-server_4.95.1_amd64.deb \
 && rm code-server_4.95.1_amd64.deb

# ===============================
# Clone ComfyUI
# ===============================
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# ===============================
# Custom nodes (YOUR fork included)
# ===============================
WORKDIR /workspace/ComfyUI/custom_nodes

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git \
 && git clone https://github.com/shaikshan/ComfyUi-WanVideoWrapper.git \
 && git clone https://github.com/kijai/ComfyUI-KJNodes.git \
 && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# ===============================
# SageAttention (compiled)
# ===============================
WORKDIR /workspace
RUN pip install --no-cache-dir sageattention==1.0.6




# ===============================
# FlashAttention (prebuilt, CUDA 12.8)
# ===============================
# RUN pip install --no-cache-dir --no-build-isolation flash-attn==2.8.3



# ===============================
# Startup scripts
# ===============================
COPY scripts/ /workspace/scripts/
RUN chmod +x /workspace/scripts/*.sh

# ===============================
# Ports
# ===============================
EXPOSE 8188 8888

# ===============================
# Entrypoint
# ===============================
CMD ["/workspace/scripts/start_all.sh"]
