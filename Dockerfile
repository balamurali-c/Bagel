FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install gradio

COPY . .

EXPOSE 8000

CMD ["python", "app.py"]
