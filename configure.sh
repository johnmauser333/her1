#!/bin/sh

# Download and install V2Ray
mkdir /tmp/xray
wget -q https://github.com/XTLS/Xray-core/releases/download/v1.5.4/Xray-linux-64.zip -O /tmp/xray/xray.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/xray

# V2Ray new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
// reverse proxy portal
  "reverse": {
    "portals": [
      {
        "tag": "portal",
        "domain": "apacheapache.com.jp"  // the same as bridge
      }
    ]
  },
// v2ray + ws + tls config
  "inbounds": [
  // receive client's connection
    {  
      // 接受 C 的inbound
      "tag": "external", // 标签，路由中用到
      "port": $PORT,
      // 开放 80 端口，用于接收外部的 HTTP 访问 
      "protocol": "dokodemo-door",
        "settings":{  
          "address": "0.0.0.0",
          "port": $PORT, //假设 NAS 监听的端口为 80
          "timeout": 5,
          "userLevel": 0,
          "network": "tcp"
      },
  
    "tag": "clientin",
    "port": $PORT,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "$UUID",
          "alterId": 0
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/v2ray"
      }
    }
  },
// receive bridge's connection
  {
    "tag": "interconn",
    "port": $PORT,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "$UUID",
          "alterId": 0
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/"
      }
    }  
  }
], // end of the inbounds
// outbounds for network proxy
  "outbounds": [{
    "tag": "crossfire",
    "protocol": "freedom",
    "settings": {}
  }],
// routing rules
  "routing": {
    "rules": [
      {
        "type": "field",
        "inboundTag": ["interconn"],
        "outboundTag": "portal"
      },
      {
        "type": "field",
        "inboundTag": ["external"],
        "outboundTag": "portal"
      },
      {
        "type": "field",
        "inboundTag": ["clientin"],
        "ip": "192.168.50.50",
        "port": "80,443",
        "outboundTag": "portal"  // for a specific ip and port range to access remote services
      },
      {
        "type": "field",
        "inboundTag": ["clientin"],
        "outboundTag": "crossfire"  // remaining traffic goes here
      }
    ]
  }
}
EOF

# Run V2Ray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json
