# Use official Python image
FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install OS dependencies (optional, based on Bagel needs)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    cmake \
    ninja-build \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENV MAX_JOBS=4

# Copy dependencies and install them
COPY requirements.txt .

RUN pip install --no-cache-dir packaging setuptools wheel

# The base image already ships with torch 2.5.0+cu122; we only need matching torchvision
RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu121 torchvision==0.20.1

RUN pip install git+https://github.com/HazyResearch/flash-attention.git@v2.5.8#subdirectory=csrc

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install gradio

# Copy source code
COPY . .

# Run the model download script during image build
RUN python download_model.py

# Expose the port your app runs on
EXPOSE 8000

# Start the app (adjust if your entrypoint is different)
CMD ["python", "app.py"]
