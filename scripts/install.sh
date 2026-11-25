#!/usr/bin/env bash
set -eu

case "$(uname -s)/$(uname -m)" in
    Linux/x86_64|Linux/amd64) ;;
    *) echo "本仓库仅提供 Linux amd64 版本" >&2; exit 1 ;;
esac

url="https://github.com/lizuojun04/kd/releases/latest/download/kd_linux_amd64"
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
