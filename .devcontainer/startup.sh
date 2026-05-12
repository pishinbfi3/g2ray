#!/bin/bash

# خواندن متغیرهای مخفی
BOT_TOKEN="${BALE_BOT_TOKEN}"
CHAT_ID="${BALE_CHAT_ID}"

# اطلاعات کانفیگ (مطابق config.json)
UUID="550e8400-e29b-41d4-a716-446655440000"
DOMAIN="${CODESPACE_NAME}-443.app.github.dev"
PORT="443"
VLESS_LINK="vless://${UUID}@${DOMAIN}:${PORT}?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${DOMAIN}#G2RAY"

# تابع ارسال پیام به بله
send_to_bale() {
    local message="$1"
    if [[ -n "$BOT_TOKEN" && -n "$CHAT_ID" ]]; then
        curl -s -X POST "https://tapi.bale.ai/bot${BOT_TOKEN}/sendMessage" \
            -H "Content-Type: application/json" \
            -d "{\"chat_id\":${CHAT_ID},\"text\":\"${message}\"}" > /dev/null
    else
        echo "⚠️ Warning: BALE_BOT_TOKEN or BALE_CHAT_ID not set. Message not sent."
    fi
}

# نمایش بنر در لاگ
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          🚀 G2RAY - XRAY SERVICE INITIALIZED 🚀           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configuration:"
echo "   • Config File: /etc/config.json"
echo ""
echo "🔗 VLESS Connection Details:"
echo "   • Link: ${VLESS_LINK}"
echo "   • Encryption: none"
echo "   • Security: tls"
echo "   • Type: xhttp"
echo "   • Mode: packet-up"
echo "   • SNI: ${DOMAIN}"
echo ""

# ارسال لینک و اطلاعات به بله
MESSAGE=$(printf "🔰 *G2RAY Config Ready*\n\n\`\`\`\n%s\n\`\`\`\n\n📡 IP: %s\n🔌 Port: %s\n🛡️ SNI: %s" "${VLESS_LINK}" "${DOMAIN}" "${PORT}" "${DOMAIN}")
send_to_bale "$MESSAGE"

echo "✨ Service is running and ready to accept connections..."
exec /usr/local/bin/xray -c /etc/config.json
