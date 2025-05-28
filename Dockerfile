# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install OS dependencies (optional, based on Bagel needs)
RUN apt-get update && apt-get install -y git && apt-get clean

# Copy dependencies and install them
COPY requirements.txt .
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
