#!/bin/bash
# Install Homebrew (and Apple's command line tools, which it pulls in) if missing.
set -euo pipefail

[[ -x /opt/homebrew/bin/brew ]] && exit 0

echo "==> Installing Homebrew (asks for your password once)"
sudo -v
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
