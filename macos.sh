#! /bin/zsh

# PRE CHECKLIST
#
# - ensure ssh backup in icloud drive containing key pair and config
# - save desktop and downloads contents

# TODO
#
# - display resolution to more space
# - set wallpaper from ~/wallpaper.png
# - dock to finder, chrome, messages, mail, photos, calendar, reminders, notes
# - keyboard modifier keys
# - siri keyboard shortcut to option space
# - finder favorites to home, applications, desktop, icloud drive, downloads
# - finder toolbar to new folder, get info, delete, space, search
# - mail favorites removed
# - notes diable group by date for each folder
# - widgets to weather, calendar, stocks
# - copy ssh backup and ssh-add to authentication agent
# - set up global git ssh signing

# BTT CONFIG
#
# - import license from icloud drive
#
# - F11 execute terminal command async
#   osascript -e "set Volume 3.5" && afplay /System/Library/LoginPlugins/BezelServices.loginPlugin/Contents/Resources/volume.aiff
#
# - F12 clipboard manager with java script transformer "Visible ASCII" (32 – 126 and newlines)
#   async clipboardContentString => clipboardContentString.replace(/[^\x20-\x7E\n]/g, "")
#
# - enable launch btt on startup
# - disable automatic update checking


# close any open system preferences windows
osascript -e 'tell application "System Preferences" to quit'

# acquire admin upfront
sudo -v

# keep admin alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> "$HOME/.zprofile"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

# install casks
brew install --cask google-chrome
brew install --cask visual-studio-code
brew install --cask iina
softwareupdate --install-rosetta --agree-to-license
brew install --cask folx
# clion <= 2023 for teach.cs ?
# office

# install btt
curl "https://folivora.ai/releases/btt3.9993-2193.zip" -o "$HOME/Downloads/btt.zip"
unzip -q "$HOME/Downloads/btt.zip" -d /Applications
rm -f "$HOME/Downloads/btt.zip"

# download wallpaper
curl "https://raw.githubusercontent.com/skrukwa/macos-config/main/wallpaper.png" -o "$HOME/wallpaper.png"

# zsh syntax highlighting
brew install zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# set zsh prompt
cat >> ~/.zshrc << 'EOF'
PROMPT="%F{yellow}[%n@%m %1~]%#%f "
EOF

# set bash prompt
cat >> ~/.bashrc << 'EOF'
PS1="\e[0;33m[\u@\h \W]\$\e[m "
EOF

###############################################################################################
# FINDER                                                                                      #
###############################################################################################

# new finder windows show icloud drive
defaults write com.apple.finder NewWindowTarget -string PfID

# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# set finder default view style to list view
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

# enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

killall Finder

###############################################################################################
# SOUND                                                                                       #
###############################################################################################

# disable play sound on startup
sudo nvram SystemAudioVolume=" " ### DID NOT WORK ON SEQUOIA

###############################################################################################
# GENERAL                                                                                     #
###############################################################################################

# set local host name
sudo scutil --set LocalHostName skrukwa-mba

###############################################################################################
# ACCESSIBILITY                                                                               #
###############################################################################################

# disable shake mouse pointer to locate
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool false ### DID NOT WORK ON SEQUOIA

###############################################################################################
# APPEARANCE                                                                                  #
###############################################################################################

# disabling wallpaper tinting
defaults write com.apple.finder ProhibitWallpaperTinting -bool true ### DID NOT WORK ON SEQUOIA

###############################################################################################
# CONTROL CENTER                                                                              #
###############################################################################################

# enable show battery percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# don't show spotlight in menu bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# don't show siri in menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false

###############################################################################################
# DESKTOP AND DOCK                                                                            #
###############################################################################################

# dock size
defaults write com.apple.dock tilesize -int 64

# position on screen left
defaults write com.apple.dock orientation -string left

# double-click a window's title bar to fill
defaults write NSGlobalDomain AppleActionOnDoubleClick -string Fill 

# enable automatically hide and show the dock
defaults write com.apple.dock "autohide" -bool true

# disable show suggested and recent apps in dock
defaults write com.apple.dock "show-recents" -bool false

# make dock fast
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# click wallpaper to reveal desktop only in stage manager
defaults write com.apple.WindowManager StandardClickToShowDesktopMode -int 1 ### DID NOT WORK ON SEQUOIA

# disable tiled windows have margins
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

killall Dock

###############################################################################################
# LOCK SCREEN                                                                                 #
###############################################################################################

# never start screen saver when inactive
defaults -currentHost write com.apple.screensaver idleTime -int 0

# turn display off on battery when inactive for 5 minutes
sudo pmset -b displaysleep 5

# turn display off on power adapter when inactive for 10 minutes
sudo pmset -c displaysleep 10

# require password after screen saver begins or display is turned off immediately
defaults write com.apple.screensaver askForPassword -int 1 ### DID NOT WORK ON SEQUOIA
defaults write com.apple.screensaver askForPasswordDelay -int 0 ### DID NOT WORK ON SEQUOIA

###############################################################################################
# TRACKPAD                                                                                    #
###############################################################################################

# set light clicking
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# enable quiet click
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0

# enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true ### DID NOT UPDATE SEQUOIA SETTINGS (but worked) (possibly because it did not update secondary click to click or tap?)

# disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################################
# KEYBOARD                                                                                    #
###############################################################################################

# disable capitalize words automatically
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "Done. Please restart now."
