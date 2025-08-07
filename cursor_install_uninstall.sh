#!/bin/bash

set -e

APP_NAME="Cursor"
APP_DIR="$HOME/AppImages/$APP_NAME"
APP_BIN="$APP_DIR/Cursor.AppImage"
WRAPPER="$APP_DIR/run_cursor.sh"
SYMLINK="$HOME/bin/cursor"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
ICON_PATH="$APP_DIR/cursor.png" # Optional: used for menu icon

# Replace with the actual URL or path
CURSOR_URL="https://downloads.cursor.com/production/d01860bc5f5a36b62f8a77cd42578126270db343/linux/x64/Cursor-1.4.2-x86_64.AppImage"

install_cursor() {
    echo "[*] Installing $APP_NAME..."

    mkdir -p "$APP_DIR"
    mkdir -p "$HOME/bin"

    echo "[*] Downloading AppImage..."
    curl -L "$CURSOR_URL" -o "$APP_BIN"
    chmod +x "$APP_BIN"

    echo "[*] Creating wrapper script..."
    cat > "$WRAPPER" <<EOF
#!/bin/bash
exec "$APP_BIN" --no-sandbox "\$@"
EOF
    chmod +x "$WRAPPER"

    echo "[*] Creating symlink at $SYMLINK"
    ln -sf "$WRAPPER" "$SYMLINK"

    echo "[*] Creating desktop entry..."
    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Cursor
Exec=$WRAPPER
Icon=$ICON_PATH
Terminal=false
Categories=Development;IDE;
EOF

    chmod +x "$DESKTOP_FILE"
    update-desktop-database "$HOME/.local/share/applications" || true

    echo "[*] Done. You can now launch Cursor from the app menu or with 'cursor'"
}

uninstall_cursor() {
    echo "[*] Uninstalling $APP_NAME..."

    rm -f "$SYMLINK"
    rm -f "$DESKTOP_FILE"
    rm -rf "$APP_DIR"

    echo "[*] Removed symlink, .desktop entry, and app image directory."
}

case "$1" in
    --uninstall)
        uninstall_cursor
        ;;
    *)
        install_cursor
        ;;
esac
