defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

defaults write -g AppleScrollerPagingBehavior -bool true
defaults write -g NSAutomaticCapitalizationEnabled -bool false

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

sudo pmset -a powernap 0
sudo pmset -b gpuswitch 2
sudo pmset -c gpuswitch 1
sudo pmset -a standby 1
