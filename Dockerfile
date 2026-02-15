# Use Node.js 22 Alpine as base image
FROM node:22-alpine

# Set environment variables
ENV NODE_ENV=production \
    CLAWDBOT_NO_PROMPT=1 \
    CLAWDBOT_NO_ONBOARD=1 \
    CLAWDBOT_INSTALL_METHOD=npm \
    SHARP_IGNORE_GLOBAL_LIBVIPS=1

# Install required system dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    ca-certificates \
    python3 \
    make \
    g++ \
    && rm -rf /var/cache/apk/*

# Create app directory
WORKDIR /app

# Copy installation script
COPY install.sh /tmp/install.sh

# Make install script executable and run installation
RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh && \
    rm -f /tmp/install.sh

# Create non-root user for running the bot
RUN addgroup -g 1000 clawdbot && \
    adduser -D -u 1000 -G clawdbot clawdbot && \
    mkdir -p /home/clawdbot/clawd && \
    chown -R clawdbot:clawdbot /home/clawdbot

# Switch to non-root user
USER clawdbot

# Set working directory to user home
WORKDIR /home/clawdbot

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD clawdbot --version || exit 1

# Default command
CMD ["clawdbot"]
