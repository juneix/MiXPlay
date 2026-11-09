#!/usr/bin/env bash
# ==============================================================================
# MiXPlay - Docker / NAS 声卡只读诊断脚本
#
# 用法：
#   bash scripts/check-audio.sh                 # 默认容器 mixplay、控制台 8820
#   bash scripts/check-audio.sh mixplay 8820   # 指定容器名 / 端口
#   curl -fsSL https://raw.githubusercontent.com/juneix/MiXPlay/main/scripts/check-audio.sh | bash
#
# 只读取信息：不修改任何配置、不写文件、不重启容器。
# ==============================================================================
set -u

CONTAINER="${1:-mixplay}"
WEB_PORT="${2:-${WEB_PORT:-8820}}"
BASE="http://127.0.0.1:${WEB_PORT}"

if [ -t 1 ]; then
  GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; BOLD='\033[1m'; NC='\033[0m'
else
  GREEN=''; YELLOW=''; RED=''; BOLD=''; NC=''
fi

PASS=0; WARN=0; FAIL=0
ok()    { printf "  ${GREEN}[OK]${NC} %s\n" "$1"; PASS=$((PASS + 1)); }
warn()  { printf "  ${YELLOW}[!]${NC}  %s\n" "$1"; WARN=$((WARN + 1)); }
fail()  { printf "  ${RED}[X]${NC}  %s\n" "$1"; FAIL=$((FAIL + 1)); }
info()  { printf "        %s\n" "$1"; }
title() { printf "\n${BOLD}== %s ==${NC}\n" "$1"; }

printf "${BOLD}MiXPlay 声卡只读诊断${NC}  容器=%s 控制台=%s\n" "$CONTAINER" "$BASE"

# Docker 可能需要提权
DOCKER="docker"
if ! docker info >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1 && sudo -n docker info >/dev/null 2>&1; then
    DOCKER="sudo docker"
  fi
fi

STATE=""
title "1/5 宿主声卡"
if [ -d /dev/snd ]; then
  ok "宿主 /dev/snd 存在"
  info "节点: $(ls /dev/snd 2>/dev/null | tr '\n' ' ')"
else
  fail "宿主没有 /dev/snd（无声卡或驱动未加载）"
fi
if command -v aplay >/dev/null 2>&1; then
  HOST_CARDS="$(aplay -l 2>/dev/null | grep -c '^card' || true)"
  if [ "${HOST_CARDS:-0}" -gt 0 ] 2>/dev/null; then
    ok "宿主 aplay 识别到 ${HOST_CARDS} 张声卡"
  else
    warn "宿主 aplay 未列出声卡"
  fi
else
  info "宿主未安装 alsa-utils(aplay)，跳过宿主枚举；以容器内结果为准"
fi

title "2/5 容器与设备映射"
if ! $DOCKER info >/dev/null 2>&1; then
  fail "无法访问 Docker（需要 root 或 sudo 权限）"
else
  STATE="$($DOCKER inspect -f '{{.State.Status}}' "$CONTAINER" 2>/dev/null || true)"
  if [ "$STATE" = "running" ]; then
    ok "容器 $CONTAINER 正在运行"
  else
    fail "容器 $CONTAINER 状态为 '${STATE:-未找到}'"
  fi
  DEVICES="$($DOCKER inspect -f '{{json .HostConfig.Devices}}' "$CONTAINER" 2>/dev/null || echo '[]')"
  NETWORK="$($DOCKER inspect -f '{{.HostConfig.NetworkMode}}' "$CONTAINER" 2>/dev/null || echo '?')"
  if printf '%s' "$DEVICES" | grep -q '/dev/snd'; then
    ok "devices 包含 /dev/snd"
  else
    fail "devices 未包含 /dev/snd -> 控制台声卡列表为空"
    info "当前: $DEVICES"
    info "常见于 NAS 图形界面「编辑/应用」容器时覆盖了 devices（配置漂移）"
  fi
  if [ "$NETWORK" = "host" ]; then
    ok "network_mode=host（mDNS 依赖它）"
  else
    warn "network_mode=$NETWORK，README 要求 host"
  fi
fi

title "3/5 容器内 ALSA"
if [ "$STATE" = "running" ]; then
  if $DOCKER exec "$CONTAINER" sh -c 'test -d /dev/snd' >/dev/null 2>&1; then
    ok "容器内可见 /dev/snd"
    info "节点: $($DOCKER exec "$CONTAINER" ls /dev/snd 2>/dev/null | tr '\n' ' ')"
  else
    fail "容器内看不到 /dev/snd -> 「声卡设备」下拉框会是空列表"
    info "修复: cd <compose目录> && docker compose up -d --force-recreate"
  fi
  CARDS="$($DOCKER exec "$CONTAINER" sh -c 'aplay -l 2>/dev/null | grep -c "^card"' 2>/dev/null || echo 0)"
  if [ "${CARDS:-0}" -gt 0 ] 2>/dev/null; then
    ok "容器内 aplay 识别到 ${CARDS} 张声卡"
    $DOCKER exec "$CONTAINER" aplay -l 2>/dev/null | grep '^card' | head -5 | while IFS= read -r l; do info "$l"; done
  else
    fail "容器内 aplay 报 no soundcards found"
  fi
else
  info "容器未运行，跳过"
fi

title "4/5 播放测试音"
if [ "$STATE" = "running" ]; then
  WAV_PATH="/usr/local/lib/python3.12/site-packages/mixplay/web/static/speaker-test.wav"
  if $DOCKER exec "$CONTAINER" sh -c "test -f '$WAV_PATH'" >/dev/null 2>&1; then
    WAV="$WAV_PATH"
  else
    WAV="$($DOCKER exec "$CONTAINER" sh -c 'find /usr/local/lib/python3.12/site-packages/mixplay -name speaker-test.wav -print 2>/dev/null | head -1' 2>/dev/null || true)"
  fi
  if [ -n "${WAV:-}" ]; then
    ok "镜像内已包含测试音: $WAV"
  else
    fail "镜像内缺少 speaker-test.wav -> 「播放测试」恒报「无法发声」"
    info "这是镜像打包问题，与声卡无关；v1.4.6 及之前版本会命中"
    info "临时处理见 README「声卡自检与故障排查」，或等待镜像修复"
  fi
else
  info "容器未运行，跳过"
fi

title "5/5 控制台接口"
if command -v curl >/dev/null 2>&1; then
  RAW="$(curl -fsS --max-time 5 "$BASE/api/audio/devices" 2>/dev/null || true)"
  if [ -n "${RAW:-}" ]; then
    case "$RAW" in
      *'"devices":[]'*|*'"devices": []'*)
        warn "接口正常但设备列表为空: $RAW"
        info "此时前端显示「加载失败」是误报，真实原因是未检测到声卡"
        ;;
      *)
        ok "接口返回设备: $(printf '%s' "$RAW" | cut -c1-220)"
        ;;
    esac
  else
    warn "无法读取 $BASE/api/audio/devices（控制台未启动或端口不是 ${WEB_PORT}）"
  fi
  STATUS="$(curl -fsS --max-time 5 "$BASE/api/status" 2>/dev/null || true)"
  if [ -n "${STATUS:-}" ]; then
    case "$STATUS" in
      *'"warnings":[]'*|*'"warnings": []'*) ok "服务状态无告警" ;;
      *) warn "服务状态含告警: $(printf '%s' "$STATUS" | cut -c1-220)" ;;
    esac
  fi
else
  info "未安装 curl，跳过接口检查"
fi

printf "\n${BOLD}==== 诊断完成: %s 项正常 / %s 项提醒 / %s 项异常 ====${NC}\n" "$PASS" "$WARN" "$FAIL"
if [ "$FAIL" -gt 0 ]; then
  printf "建议优先处理 [X] 项，完整说明见 README「声卡自检与故障排查」。\n"
  printf "重建容器前请确认 ./conf 卷已保留（小米登录态与音箱配置都在里面）。\n"
fi
exit 0
