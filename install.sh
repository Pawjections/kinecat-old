#!/usr/bin/env bash
set -euo pipefail

echo "Kinecat macOS installer"

# Install Homebrew if not found
if ! command -v brew >/dev/null 2>&1; then
  echo "[INFO] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
echo "[INFO] Updating Homebrew..."
brew update

# Ensure brew binaries take precedence
export PATH="$(brew --prefix)/bin:$PATH"

# ---------- 1. Dependencies ----------
echo "[INFO] Installing dependencies..."
brew install \
  cmake \
  pkg-config \
  libusb \
  glfw \
  glew \
  opencv \
  python@3.11

# ---------- 2. Python ----------
PYTHON="$(brew --prefix)/bin/python3.11"
PIP="$PYTHON -m pip"

echo "[INFO] Using Python: $($PYTHON --version)"

$PIP install --upgrade pip
$PIP install "setuptools<69" wheel numpy cython opencv-python

# ---------- 3. Build libfreenect2 ----------
if [ ! -d "libfreenect2" ]; then
  git clone https://github.com/OpenKinect/libfreenect2.git
fi

cd libfreenect2
mkdir -p build && cd build

cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_EXAMPLES=OFF \
  -DENABLE_OPENGL=ON \
  -DENABLE_OPENCL=OFF

make -j"$(sysctl -n hw.ncpu)"
sudo make install

cd ../..

# ---------- 4. pylibfreenect2 ----------
if [ ! -d "pylibfreenect2" ]; then
  git clone https://github.com/r9y9/pylibfreenect2.git
fi

export LIBFREENECT2_INSTALL_PREFIX=/usr/local
export DYLD_LIBRARY_PATH=/usr/local/lib:${DYLD_LIBRARY_PATH:-}

cd pylibfreenect2
$PIP install . --no-build-isolation
cd ..

# ---------- 5. Verify Kinect ----------
# echo "[INFO] Verifying Kinect device..."
# $PYTHON - << 'EOF'
# from pylibfreenect2 import Freenect2
# fn = Freenect2()
# n = fn.enumerateDevices()
# print("Devices found:", n)
# if n == 0:
#     raise SystemExit("No Kinect v2 device detected")
# EOF

# ---------- 6. Run viewer ----------
echo "[INFO] Launching viewer.py..."
$PYTHON viewer.py
