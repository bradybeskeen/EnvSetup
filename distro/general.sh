# Distro Agnostic Functions

# Install Go Mono Nerf Font
wget -O gomono_nerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Go-Mono.zip
unzip -d gomono_nerd gomono_nerd.zip
mkdir -p $HOME/.local/share/fonts
cp gomono_nerd/*.ttf $HOME/.local/share/fonts/
rm -rf gomono_nerd
fc-cache -f
