#!/bin/bash
##makedesc: Install lite-xl v2.0.5 (draft)


# DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT
# DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT
# DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT
# DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT
# DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT DRAFT

# https://github.com/lite-xl/lite-xl

[ $1 ] && LITEXLVER="$1" || LITEXLVER="2.0.5"
echo
echo "==============================================="
echo "Installing lite-xl v${LITEXLVER}..."
echo "==============================================="
echo

wget "https://github.com/lite-xl/lite-xl/releases/download/v${LITEXLVER}/lite-xl-linux-x86_64.tar.gz" -O /tmp/lite-xl.tar.gz
sudo tar -xzf /tmp/lite-xl.tar.gz -C /tmp
mkdir -p $HOME/.local/bin && cp /tmp/lite-xl/bin/lite-xl $HOME/.local/bin
cp -r /tmp/lite-xl/share $HOME/.local
rm -rf /tmp/lite-xl*
echo -e 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.bashrc
[ -f $HOME/.zshrc ] && echo -e 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.zshrc
xdg-desktop-menu forceupdate

### uninstall
# rm -f $HOME/.local/bin/lite-xl
# rm -rf $HOME/.local/share/icons/hicolor/scalable/apps/lite-xl.svg \
#     $HOME/.local/share/applications/org.lite_xl.lite_xl.desktop \
#     $HOME/.local/share/metainfo/org.lite_xl.lite_xl.appdata.xml \
#     $HOME/.local/share/lite-xl
