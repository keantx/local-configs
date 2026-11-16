### install first

```bash
sudo apt update
sudo apt install -y zsh vim less fzf bat eza \
  zsh-autosuggestions zsh-syntax-highlighting curl ghostty
curl -sS https://starship.rs/install.sh | sh
chsh -s "$(command -v zsh)"
```

```bash
brew install fzf bat eza starship \
  zsh-autosuggestions zsh-syntax-highlighting \
  azure-cli kubectl

brew install --cask font-jetbrains-mono-nerd-font
``` 