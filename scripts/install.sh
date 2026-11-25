#!/usr/bin/env bash
set -eu

case "$(uname -s)" in
    Linux) platform=linux ;;
    Darwin) platform=macos ;;
    *) echo "此脚本仅支持 Linux 和 macOS" >&2; exit 1 ;;
esac
case "$(uname -m)" in
    x86_64|amd64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) echo "暂不支持此架构" >&2; exit 1 ;;
esac

url="https://github.com/lizuojun04/kd/releases/latest/download/kd_${platform}_${arch}"
bin_dir="$HOME/.local/bin"
mkdir -p "$bin_dir"
tmp=$(mktemp "$bin_dir/.kd.XXXXXXXX")
trap 'rm -f "$tmp"' EXIT

echo "正在下载 $url"
if command -v curl >/dev/null; then
    curl -fL -o "$tmp" "$url"
elif command -v wget >/dev/null; then
    wget -O "$tmp" "$url"
else
    echo "请先安装 curl 或 wget" >&2
    exit 1
fi
chmod 755 "$tmp"
mv -f "$tmp" "$bin_dir/kd"
echo "已安装到 $bin_dir/kd"
case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) echo '要直接运行 kd，请将 export PATH="$HOME/.local/bin:$PATH" 加入 shell 配置。' ;;
esac
"$bin_dir/kd" --version
"$bin_dir/kd" --daemon
