# MiXPlay 

MiXPlay（隔空妙播）是一个面向局域网的**开放式音频中枢**，它融合了 AirPlay（隔空播放）、小米妙播（MiPlay）协议等多种音频能力，内置首发🔥`MiXPlay 全屋播放`，另有 `Web 虚拟音箱`、`通用音频 API`、`兼容 OwnTone` 等开放式玩法。

### 📢 上游鸣谢与开源合规说明

本项目的基础协议桥接能力整合了以下优秀的开源组件：
- **小米账号与云端通讯**：[miservice-fork](https://pypi.org/project/miservice-fork/) (MIT)
- **小米妙播协议（MiPlay）**：[FusionPlay-Android](https://github.com/rosienosiesie/FusionPlay-Android) (MIT)
- **隔空播放（AirPlay 1/2）**：[shairplay-rust](https://github.com/metaneutrons/shairplay-rust) (LGPL-3.0)

> **💡 灵感与思路参考**：
> 本项目在开发与设计过程中，还参考了以下社区项目的思路并进行了重构与自用优化，在此特别致谢：
> - [MiAir](https://github.com/KiriChen-Wind/MiAir) / [miair-next](https://github.com/deerwan/miair-next) / [XiaoMusic](https://github.com/hanxi/xiaomusic)

**📌 功能边界与授权说明**：
- **基础免费能力**：基于上述上游组件实现的单设备直通播放、单机声卡输出、小米音箱 1v1 桥接等基础功能**完全免费开放使用**。
- **自研赞助模块**：本项目自研的 `Audio Hub 音频流转中枢`、`MiXPlay 全屋同步播放`、`Web 虚拟音箱集群`等组合玩法属于个人定制扩展，作为可选的赞助解锁功能。
- **第三方开源许可全文**：详见项目中的 [THIRD-PARTY-NOTICES.md](./THIRD-PARTY-NOTICES.md) 与 [LICENSE](./LICENSE)。

![mixplay-1.webp](./img/mixplay-1.webp)

![mixplay-2.webp](./img/mixplay-2.webp)

## ✨ 功能特色

- 🚀 **桥接 AirPlay**：局域网直连播放，低延迟无损直通
- 🚀 **模拟 MiPlay**：局域网直连播放，低延迟无损直通
- 🔥 **多房间同步播放**：定制版`MiXPlay 全屋播放`
- 🌐 **Web 虚拟音箱**：任意网页变虚拟音箱，展示歌曲信息
- 🔌 **通用音频 API**：标准的流媒体接口，轻松对接音乐库
- 🔥 **接入 OwnTone**：兼容跨协议的`多房间播放`
  - OwnTone 支持 AirPlay 1&2、Chromecast、DLNA 等
- 📦 **多平台通用**：支持 Windows、macOS、Linux、Android Termux 及 Docker 部署

> MiXPlay 内置纯 Rust 原生 AirPlay 驱动（原生支持 AirPlay 2 及 AirPlay 1 协议），无需安装复杂的 C 语言依赖即可享受极低延迟无损直通。

### 📊 音频方案与协议对比

| 对比维度 | MiXPlay | AirPlay 1| AirPlay 2 | DLNA | 小米妙播 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **系统级音频投射** | ✅ 全家桶 | ✅ 全家桶 | ✅ 全家桶 | ❌ 部分 App |  ✅ 全家桶 |
| **多房间同步播放** | ✅ 支持 | ☑️ 仅限 iTunes | ✅ 支持 | ❌ 不支持 | ✅ 支持 |
| **音频通信链路** | ☑️ 同步串流 | ☑️ 同步串流 | ✅ 独立协同 | ☑️ 分离遥控 | ✅ 独立协同 |
| **小米音箱兼容性** | ✅ 全系音箱 | ☑️ Sound 系列  | ☑️ Sound 系列 | ☑️ 部分音箱 | ☑️ 部分音箱 |
| **OwnTone 兼容性** | ✅ 支持 | ✅ 支持  | ✅ 支持| ☑️ 部分音箱 | ❌ 不支持 |
| **小米妙播兼容性** | ✅ 支持 | ❌ 不支持  | ❌ 不支持| ❌ 不支持 | ☑️ 部分音箱 |
| **硬件加密门槛** |  ✅ 无门槛 | ☑️ 苹果授权 | ☑️ 苹果授权 | ✅ 无门槛 | 🔒 小米独占 |

> 🔊 **MiXPlay 支持音箱列表** ➡️ [点我跳转查看](./speaker.md)

### 🎵 音频处理与格式支持

* **原生直连格式**：`.mp3`、`.m4a`、`.flac`、`.wav`、`.m3u8`
  - 小米音箱硬件原生解码，音频数据由中枢直接转发，0 额外 CPU 转码开销，无损低延迟。
* **中枢转码扩展**：
  - 内置静态编译 **FFmpeg** 引擎，支持将非标准流实时转码推流至各个音箱端。

⚠️ 本项目主要是完善苹果用户的小米音箱 ✖️ AirPlay 体验，暂不考虑 DLNA 功能。
- DLNA 是一个古早的音频协议，虽然新老设备都能用，但体验不太好、稳定性欠佳
- 小米音箱自带 DLNA 功能不完整，第三方 DLNA 需额外适配，体验依然不完美
- 如果需要第三方 DLNA 功能，推荐使用 MiAir、miair-next 等项目


---

## ❤️ 支持项目

- 打赏鼓励：支持我开发更多有趣应用
- 互动群聊：加入 💬 [QQ 群](https://qm.qq.com/q/ZzOD5Qbhce) 可在线催更
- 更多内容：访问 ➡️ [谢週五の藏经阁](https://5nav.eu.org)

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="./img/wechat.webp" width="128" /><br/>
        <sub>微信</sub>
      </td>
      <td align="center">
        <img src="./img/alipay.webp" width="128" /><br/>
        <sub>支付宝</sub>
      </td>
    </tr>
  </table>
</div>



---

## 🚀 安装与运行方式

### 1、Docker 容器部署

#### Docker Compose（推荐 NAS / 服务器）

```yaml
services:
  mixplay:
    #image: docker.1ms.run/juneix/mixplay # 毫秒镜像加速
    image: ghcr.io/juneix/mixplay
    container_name: mixplay
    network_mode: host
    restart: always
    environment:
      WEB_PORT: 8820
    volumes:
      - ./conf:/app/conf
      - /etc/machine-id:/host/etc/machine-id:ro
```

#### Docker CLI

```bash
docker run -d \
  --name mixplay \
  --network host \
  --restart always \
  -e WEB_PORT=8820 \
  -v "${PWD}/conf:/app/conf" \
  -v "/etc/machine-id:/host/etc/machine-id:ro" \
  ghcr.io/juneix/mixplay
  # docker.1ms.run/juneix/mixplay # 毫秒镜像加速
```

---

### 2、飞牛应用商店 (fnOS)

在飞牛 fnOS 应用中心搜索【MiXPlay - 隔空妙播】即可在线一键安装。

![mixplay-3.webp](./img/mixplay-3.webp)

---

### 3、全平台通用

#### a. 已有 uv 环境
```bash
uv tool install --python 3.12 mixplay-hub
```

#### b. 一键安装 uv 和 mixplay
```bash
# 🐧 Linux / 🍎 macOS / 📱 安卓 Termux (Linux 自动注册 Systemd 开机自启服务，Mac 自动生成桌面快捷方式)
curl -fsSL https://raw.githubusercontent.com/juneix/MiXPlay/main/scripts/install.sh | bash

# 国内加速
curl -fsSL https://gh-proxy.org/https://raw.githubusercontent.com/juneix/MiXPlay/main/scripts/install.sh | bash

# 🪟 Windows (PowerShell 一键安装，自动生成桌面快捷方式)
powershell -ExecutionPolicy ByPass -c "irm https://raw.githubusercontent.com/juneix/MiXPlay/main/scripts/install.ps1 | iex"

# 国内加速
powershell -ExecutionPolicy ByPass -c "irm https://gh-proxy.org/https://raw.githubusercontent.com/juneix/MiXPlay/main/scripts/install.ps1 | iex"
```

> 💡 **日常使用**：
> - **桌面用户**：双击桌面的 **MiXPlay 快捷方式**（或运行 `mixplay-desktop`），自动常驻系统托盘并拉起网页控制台，右键托盘图标可快速打开控制台、查看日志或退出；
> - **服务器/NAS 用户**：后台守护模式运行 `mixplay serve -d`，停止服务运行 `mixplay stop`。


---

## 🔐 小米账号与登录凭证说明

1. **登录方式推荐与区别**
   - **米家 App 扫码登录 (强烈推荐 ⭐⭐⭐⭐⭐)**：
     通过移动端米家 App 原生扫码授权，获取官方长效根凭证 `passToken`。**有效期长达数月至半年**，且后台会自动无感静默续期，100% 绕过滑块验证码与异地风控。
   - **手动 Cookie 登录 (备用)**：
     通过浏览器 F12 抓取网页版 Cookie（`userId` + `passToken`），作为备用方案。网页 Cookie 有效期相对较短（通常数周），且若在电脑浏览器点击“退出登录”会立即失效。

2. **为什么不支持账号密码直接登录？**
   直接提交账号密码极易触发小米云端的安全风控（如图片验证码、短信二次验证、异地设备异常封禁），导致换票失败率极高，故不提供该方式。

3. **自动续期原理**
   系统基于保存的 `passToken`，后台会自动向小爱云端静默换取播放所需的短期通行证（`serviceToken`，通常有效期 30 天），全自动轮转，日常使用无需手动干预。

4. **安全与隐私提示**
   ⚠️ 小米的 `passToken` 为核心凭据，请妥善保管勿公开泄露。本项目纯内网个人使用，Web 控制台默认无需密码。如需外网访问，强烈建议配合 `Tailscale`、`Zerotier` 或 VPN 使用。
