# Python Enterprise Base Image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for health monitoring
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Copy health check script
COPY health_check.py .

# Configure health monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python health_check.py

# Create security user (non-root)
RUN useradd -m -u 1000 platformuser && chown -R platformuser:platformuser /app
USER platformuser

# Expose application port
EXPOSE 8501

# Start Intelligent MLOps Platform
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]