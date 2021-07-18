# Vmess-Heroku

## 概述

**可以部署两个以上的应用，实现 [负载均衡](https://toutyrater.github.io/routing/balance2.html)，避免长时间大流量连接某一应用而被 Heroku 判定为滥用。**

**可导入Qv2ray\v2rayN\WinXray等软件使用。**

**请使用 CDN，不要使用 Heroku 分配的域名，以实现更快的速度，更优质的网络环境体验。**

## 镜像


[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https%3A%2F%2Fgithub.com%2FSaverFoods%2Fcreate-v.m)

## ENV 设定

### UUID

`UUID` > `一个 UUID，供用户连接时验证身份使用`。

## 注意

`alterId` 为 `64`。

WebSocket 路径为 `/`。

V2Ray 将在部署时自动安装最新版本

