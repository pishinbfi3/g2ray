FROM debian:bookworm-slim

COPY install.sh /app/install.sh

WORKDIR /app

# Install dependencies with clear output
RUN echo "📦 Installing system dependencies..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && echo "✅ Dependencies installed successfully" \
    && rm -rf /var/lib/apt/lists/*

# Setup and configure xray
RUN echo "⚙️  Running installation script..." && \
    chmod +x /app/install.sh && /app/install.sh && \
    echo "✅ Installation completed successfully"

COPY config.json /etc/config.json

# Create startup message with clear banner
RUN echo '#!/bin/bash' > /app/startup.sh && \
    echo 'BOT_TOKEN="${BALE_BOT_TOKEN}"' >> /app/startup.sh && \
    echo 'CHAT_ID="${BALE_CHAT_ID}"' >> /app/startup.sh && \
    echo 'UUID="550e8400-e29b-41d4-a716-446655440000"' >> /app/startup.sh && \
    echo 'DOMAIN="${CODESPACE_NAME}-443.app.github.dev"' >> /app/startup.sh && \
    echo 'PORT="443"' >> /app/startup.sh && \
    echo 'VLESS_LINK="vless://${UUID}@${DOMAIN}:${PORT}?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${DOMAIN}#G2RAY"' >> /app/startup.sh && \
    echo 'send_to_bale() {' >> /app/startup.sh && \
    echo '    local message="$1"' >> /app/startup.sh && \
    echo '    if [[ -n "$BOT_TOKEN" && -n "$CHAT_ID" ]]; then' >> /app/startup.sh && \
    echo '        curl -s -X POST "https://tapi.bale.ai/bot${BOT_TOKEN}/sendMessage" -H "Content-Type: application/json" -d "{\"chat_id\":${CHAT_ID},\"text\":\"${message}\"}" > /dev/null' >> /app/startup.sh && \
    echo '    else' >> /app/startup.sh && \
    echo '        echo "⚠️ Warning: BALE_BOT_TOKEN or BALE_CHAT_ID not set. Message not sent."' >> /app/startup.sh && \
    echo '    fi' >> /app/startup.sh && \
    echo '}' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "╔════════════════════════════════════════════════════════════╗"' >> /app/startup.sh && \
    echo 'echo "║          🚀 G2RAY - XRAY SERVICE INITIALIZED 🚀           ║"' >> /app/startup.sh && \
    echo 'echo "╚════════════════════════════════════════════════════════════╝"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "📋 Configuration:"' >> /app/startup.sh && \
    echo 'echo "   • Config File: /etc/config.json"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "🔗 VLESS Connection Details:"' >> /app/startup.sh && \
    echo 'echo "   • Link: ${VLESS_LINK}"' >> /app/startup.sh && \
    echo 'echo "   • Encryption: none"' >> /app/startup.sh && \
    echo 'echo "   • Security: tls"' >> /app/startup.sh && \
    echo 'echo "   • Type: xhttp"' >> /app/startup.sh && \
    echo 'echo "   • Mode: packet-up"' >> /app/startup.sh && \
    echo 'echo "   • SNI: ${DOMAIN}"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'MESSAGE=$(printf "🔰 *G2RAY Config Ready*\n\n```\n%s\n```\n\n📡 IP: %s\n🔌 Port: %s\n🛡️ SNI: %s" "${VLESS_LINK}" "${DOMAIN}" "${PORT}" "${DOMAIN}")' >> /app/startup.sh && \
    echo 'send_to_bale "$MESSAGE"' >> /app/startup.sh && \
    echo 'echo "✨ Service is running and ready to accept connections..."' >> /app/startup.sh && \
    echo 'exec /usr/local/bin/xray -c /etc/config.json' >> /app/startup.sh && \
    chmod +x /app/startup.sh

CMD ["/app/startup.sh"]
