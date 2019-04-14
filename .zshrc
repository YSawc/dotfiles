# 配列形式で変数宣言
ZSH_ARRAY=(
						.zprofile
						.zshrc.plugins_setting
						.zshrc.auto_attach
						.zshrc.basic
						.zshrc.alias
						.zshrc.apperance
						.zshrc.functions
					)

for zsh in "${ZSH_ARRAY[@]}"
do
	source ~/dotfiles/zsh/"$zsh"
done

# 環境設定
# source ~/dotfiles/zsh/.zprofile

# プラグイン設定
# source ~/dotfiles/zsh/.zshrc.plugins_setting

# 起動時自動アタッチ設定
# source ~/dotfiles/zsh/.zshrc.auto_attach

# 基本設定
# source ~/dotfiles/zsh/.zshrc.basic

# エイリアス設定
# source ~/dotfiles/zsh/.zshrc.alias

# 表示設定
# source ~/dotfiles/zsh/.zshrc.apperance

# function setting
# source ~/dotfiles/zsh/.zshrc.functions