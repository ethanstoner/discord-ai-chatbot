FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY discord_bot.py .
COPY shared_rate_limiter.py .
COPY turn_manager.py .

# Run the Discord bot
CMD ["python", "discord_bot.py"]
