#!/bin/sh

# Download and install V2Ray
mkdir /tmp/xray
wget -q https://github.com/XTLS/Xray-core/releases/download/v1.5.4/Xray-linux-64.zip -O /tmp/xray/xray.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
# install -m 755 /tmp/xray/xray /xray

# Remove temporary directory
# rm -rf /tmp/xray

# V2Ray new configuration
# install -d /xray
cat << EOF > /xray/config.json
{
    "inbounds": [
        {
            "tag": "in_tomcat",
            "port": $PORT,
            "protocol": "dokodemo-door",
            "settings": {
                "address": "127.0.0.1",
                "port": 14147,
                "network": "tcp"
            }
        },
        {
            "tag": "in_interconn",
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 0,
                        "security": "chacha20-poly1305"
                    }
                ]
            },
            "streamSettings": {
              "network": "ws"
            }
        }
    ],
    "reverse": {
        "portals": [
            {
                "tag": "portal",
                "domain": "google.com"
            }
        ]
    },
    "routing": {
        "rules": [
            {
                "type": "field",
                "inboundTag": [
                    "in_tomcat"
                ],
                "outboundTag": "portal"
            },
            {
                "type": "field",
                "inboundTag": [
                    "in_interconn"
                ],
                "outboundTag": "portal"
            }
        ]
    }
}
EOF

# Run V2Ray
/xray -config /xray/config.json
