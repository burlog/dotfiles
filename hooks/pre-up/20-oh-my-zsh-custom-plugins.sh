#!/bin/sh

if [ ! -d ~/.oh-my-zsh/custom/plugins/ ]; then
    mkdir -p ~/.oh-my-zsh/custom/plugins/
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

