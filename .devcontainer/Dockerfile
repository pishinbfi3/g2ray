FROM debian:bookworm-slim

COPY install.sh /app/install.sh
WORKDIR /app

# نصب وابستگی‌ها (curl برای ارسال به بله لازم است)
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl wget unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# نصب xray
RUN chmod +x /app/install.sh && /app/install.sh

# کپی کانفیگ xray
COPY config.json /etc/config.json

# ساخت اسکریپت استارتاپ (startup.sh)
RUN echo '#!/bin/bash' > /app/startup.sh && \
    echo 'set -e' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo '# دریافت متغیرهای محیطی (از secrets)' >> /app/startup.sh && \
    echo 'BOT_TOKEN="$BALE_BOT_TOKEN"' >> /app/startup.sh && \
    echo 'CHAT_ID="$BALE_CHAT_ID"' >> /app/startup.sh && \
    echo 'UUID="550e8400-e29b-41d4-a716-446655440000"' >> /app/startup.sh && \
    echo 'DOMAIN="${CODESPACE_NAME}-443.app.github.dev"' >> /app/startup.sh && \
    echo 'PORT="443"' >> /app/startup.sh && \
    echo 'VLESS_LINK="vless://${UUID}@${DOMAIN}:${PORT}?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${DOMAIN}#G2RAY"' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'echo "╔════════════════════════════════════════════════════════════╗"' >> /app/startup.sh && \
    echo 'echo "║          🚀 G2RAY - XRAY SERVICE INITIALIZED 🚀           ║"' >> /app/startup.sh && \
    echo 'echo "╚════════════════════════════════════════════════════════════╝"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "🔗 VLESS Link: ${VLESS_LINK}"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo '# ارسال پیام به ربات بله' >> /app/startup.sh && \
    echo 'if [[ -n "$BOT_TOKEN" && -n "$CHAT_ID" ]]; then' >> /app/startup.sh && \
    echo '    echo "📤 Sending config to Bale bot..."' >> /app/startup.sh && \
    echo '    MESSAGE=$(printf "🔰 *G2RAY Config Ready*\n\n\`\`\`\n%s\n\`\`\`\n\n📡 SNI: %s\n🔌 Port: %s" "${VLESS_LINK}" "${DOMAIN}" "${PORT}")' >> /app/startup.sh && \
    echo '    curl -s -X POST "https://tapi.bale.ai/bot${BOT_TOKEN}/sendMessage" \' >> /app/startup.sh && \
    echo '         -H "Content-Type: application/json" \' >> /app/startup.sh && \
    echo '         -d "{\"chat_id\":${CHAT_ID},\"text\":\"${MESSAGE}\"}" \' >> /app/startup.sh && \
    echo '         > /dev/null && echo "✅ Message sent successfully" || echo "❌ Failed to send message"' >> /app/startup.sh && \
    echo 'else' >> /app/startup.sh && \
    echo '    echo "⚠️ BALE_BOT_TOKEN or BALE_CHAT_ID not set. Message not sent."' >> /app/startup.sh && \
    echo 'fi' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'echo "🚀 Starting XRAY in foreground..."' >> /app/startup.sh && \
    echo 'exec /usr/local/bin/xray -c /etc/config.json' >> /app/startup.sh && \
    chmod +x /app/startup.sh

CMD ["/app/startup.sh"]
