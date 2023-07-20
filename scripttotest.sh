# back up your current configuration
backup_path="$HOME/.config/nvimbackup"

if [ -d "$backup_path" ]; then
    echo "The $backup_path folder already exists, solve this conflict before continuing."
    exit 1
else
    echo "Moving your current configuration to $backup_path"
    mv $HOME/.config/nvim $backup_path
fi

cd $HOME
# clone my configuration
git clone git@github.com:0000marcell/nvim-ruby-dap-configuration.git
# synlinc the configuration
ln -sr nvim-ruby-dap-configuration/nvim/ ~/.config/
# install packer 
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	~/.local/share/nvim/site/pack/packer/start/packer.nvim
# clone example code
git clone git@github.com:0000marcell/nvim-ruby-dap-test.git
# install example code dependencies
cd nvim-ruby-dap-test
bundle install
