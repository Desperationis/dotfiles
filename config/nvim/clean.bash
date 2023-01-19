echo -e "\033[0;31mAre you sure you want to clean your neovim config? This will completely wipe neovim and install init.lua again.\033[0;31m"
read ans

if [[ -e ~/.local/share/nvim ]]
then
	rm -rf ~/.local/share/nvim/
fi

if [[ -e ~/.config/nvim ]]
then
	rm -rf ~/.config/nvim
fi

mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim/
