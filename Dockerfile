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

# Install clawdbot globally via npm
RUN npm install -g clawdbot@latest --no-fund --no-audit

# Create non-root user for running the bot
RUN addgroup -S clawdbot && \
    adduser -D -S -G clawdbot clawdbot && \
    mkdir -p /home/clawdbot/clawd && \
    chown -R clawdbot:clawdbot /home/clawdbot

# Switch to non-root user
USER clawdbot

# Set working directory to user home
WORKDIR /home/clawdbot

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD clawdbot --version || exit 1

# Default command - keep container running
# Users can override this to run specific clawdbot commands
CMD ["tail", "-f", "/dev/null"]
