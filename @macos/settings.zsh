#!/usr/bin/env zsh

() {
  # Get the current execution context
  SCRIPT_DIR=$(cd $(dirname "${(%):-%x}") && pwd)

  # Source commons (e.g. logging)
  for libraryFile ($SCRIPT_DIR/../_lib/*.zsh $SCRIPT_DIR/../_lib/@macos/*.zsh); do
    source $libraryFile
  done

  # Adopted from Mathias Bynens' dotfiles - originally licensed under MIT
  # ~/.macos - https://mths.be/macos

  # Request elevated permissions
  elevate

  # Close any open System Settings panes -
  # this is to prevent them from overriding settings we’re about to change
  osascript -e 'tell application "System Settings" to quit'

  logger "info" "Setting macOS defaults ..."

  ###############################################################################
  # General UI/UX                                                               #
  ###############################################################################

  # Set computer name, if possible (as done via System Settings -> Sharing)

  # Set sidebar icon size to medium
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # Show scrollbars depending on the context
  # Possible values: `WhenScrolling`, `Automatic` and `Always`
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

  # Increase the window resize speed for Cocoa applications
  # This will make them open quicker
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  # Double-click to maximize windows
  defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

  # Use expanded save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool "true"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool "true"

  # Use expanded print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool "true"
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool "true"

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool "false"

  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

  # Automatically quit printer apps once the print jobs complete
  defaults write org.cups.PrintingPrefs "Quit When Finished" -bool "true"

  # Display ASCII control characters using caret notation in standard text views
  defaults write NSGlobalDomain NSTextShowsControlCharacters -bool "true"

  # Enable window-saving on quit system-wide
  defaults write -app "System Settings" NSQuitAlwaysKeepsWindows -bool "true"


  # Disable automatic termination of inactive apps
  # Commented out for now to cope with older devices
  # defaults write NSGlobalDomain NSDisableAutomaticTermination -bool "true"

  # Set Help Viewer windows to non-floating mode
  defaults write com.apple.helpviewer DevMode -bool "true"

  # Show IP address, hostname, OS version etc.,
  # when clicking the clock in the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  # Show Day of the week and 24-hour formatted clock in menu bar
  defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE HH:mm:ss\""
  defaults write com.apple.menuextra.clock "ShowDate" -bool "true"
  defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool "false"
  defaults write com.apple.menuextra.clock "ShowSeconds" -bool "true"

  # Show battery percentage in menu bar
  defaults write $HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist "BatteryShowPercentage" -bool "true"

  # Hide unwanted items in menu bar
  defaults write $HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist "Display" -int 8
  defaults write $HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist "NowPlaying" -int 8
  defaults write $HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist "ScreenMirroring" -int 8
  # defaults write $HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist "Sound" -int 8

  # Disable Notification Center and remove the menu bar icon
  # Commented out for Big Sur
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2>/dev/null

  # Disable automatic capitalization as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool "false"

  # Disable smart dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool "false"

  # Disable automatic period substitution as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool "false"

  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool "false"

  # Enable spellchecker auto language identification
  defaults write NSGlobalDomain NSSpellCheckerAutomaticallyIdentifiesLanguages -bool "true"

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool "false"


  # Improve sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Use scroll gesture with the Ctrl (^) modifier key to zoom
  sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool "true"
  sudo defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
  # Follow the keyboard focus while zoomed in
  sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool "true"

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "$HOME/Documents/screenshots"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool "true"

  # Enable font anti-aliasing rendering when font-sizes are smaller than 4px
  defaults write NSGlobalDomain AppleAntiAliasingThreshold -int 4

  # Enable subpixel font rendering on non-Apple LCDs
  # Ref: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
  defaults write NSGlobalDomain AppleFontSmoothing -int 1

  # Disable Font Smoothing Disabler in macOS Mojave
  # Ref: https://ahmadawais.com/fix-macos-mojave-font-rendering-issue/
  defaults write -g CGFontRenderingFontSmoothingDisabled -bool "false"

  # Enable HiDPI display modes (requires restart)
  sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool "true"

  ###############################################################################
  # Finder                                                                      #
  ###############################################################################

  # Set $HOME as the default location for new Finder windows
  # For other paths, use `PfLo` and `file:///full/path/here/`
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool "true"
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool "true"
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool "true"
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool "true"

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool "true"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool "true"

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool "true"

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool "true"

  # Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool "true"

  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Enable spring loading for directories
  defaults write NSGlobalDomain com.apple.springing.enabled -bool "true"

  # Use 0.5s spring loading delay for directories
  defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"

  # Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool "true"
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool "true"
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool "true"

  # Enable snap-to-grid for icons on the desktop and in other icon views
  PREFERENCES="$HOME/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$PREFERENCES"
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" "$PREFERENCES"
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$PREFERENCES"
  unset PREFERENCES

  # Use list view in all Finder windows by default
  # Four-letter codes for the other view modes: `Icnv`, `Clmv`, `Glyv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Show the ~/Library folder
  xattr -d com.apple.FinderInfo ~/Library 2>/dev/null
  chflags nohidden ~/Library

  # Expand the following File Info panes:
  # “General”, “Open with”, and “Sharing & Permissions”
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool "true" \
    OpenWith -bool "true" \
    Privileges -bool "true"

  ###############################################################################
  # Dock and Dashboard                                                          #
  ###############################################################################

  # Move the dock on the left
  defaults write com.apple.dock orientation -string "left"

  # Set the icon size of Dock items to 32 pixels
  defaults write com.apple.dock tilesize -int 32

  # Change minimize/maximize window effect
  defaults write com.apple.dock mineffect -string "scale"

  # Minimize windows into their application’s icon
  defaults write com.apple.dock minimize-to-application -bool "true"

  # Enable spring loading for all Dock items
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool "true"

  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool "true"

  # Disable Dashboard
  defaults write com.apple.dashboard dashboard-enabled-state -int 1

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool "false"

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool "true"

  # Magnify the dock on hover
  defaults write com.apple.dock magnification -bool "true"

  # Set the magnified icon size of Dock items to 48 pixels
  defaults write com.apple.dock largesize -int 48

  # Don’t show recent applications in Dock
  defaults write com.apple.dock show-recents -bool "false"

  # Reset Launchpad, but keep the desktop wallpaper intact
  find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete


  # Wipe all (default) app icons from the Dock
  defaults write com.apple.dock persistent-apps -array

  # Wipe all (default) folder icons from the Dock
  defaults write com.apple.dock persistent-others -array

  # Add frequently used apps and folders to the Dock
  for app (
    '/System/Applications/Launchpad.app'
    '/System/Applications/Music.app'
    '/Applications/Brave Browser.app'
    '/Applications/Slack.app'
    '/Applications/iTerm.app'
    '/Applications/Emacs.app'
    '/Applications/Cursor.app'
    '/System/Applications/System Settings.app'
  ); do
    add_app_to_dock $app
  done
  unset app

  for folder ($HOME/workspace $HOME/Downloads $HOME/Documents); do
    add_folder_to_dock $folder -a 2
  done
  unset folder


  ###############################################################################
  # Safari & WebKit                                                             #
  ###############################################################################

  # Privacy: don’t send search queries to Apple
  defaults write -app "Safari" UniversalSearchEnabled -bool "false"
  defaults write -app "Safari" SuppressSearchSuggestions -bool "true"

  # Press Tab to highlight each item on a web page
  defaults write -app "Safari" WebKitTabToLinksPreferenceKey -bool "true"
  defaults write -app "Safari" com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool "true"

  # Show the full URL in the address bar (note: this still hides the scheme)
  defaults write -app "Safari" ShowFullURLInSmartSearchField -bool "true"

  # Prevent Safari from opening ‘safe’ files automatically after downloading
  defaults write -app "Safari" AutoOpenSafeDownloads -bool "false"

  # Allow hitting the Backspace key to go to the previous page in history
  defaults write -app "Safari" com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool "true"

  # Hide Safari’s bookmarks bar by default
  defaults write -app "Safari" ShowFavoritesBar-v2 -bool "false"

  # Hide Safari’s sidebar in Top Sites
  defaults write -app "Safari" ShowSidebarInTopSites -bool "false"

  # Disable Safari’s thumbnail cache for History and Top Sites
  defaults write -app "Safari" DebugSnapshotsUpdatePolicy -int 2

  # Enable Safari’s debug menu
  defaults write -app "Safari" IncludeInternalDebugMenu -bool "true"

  # Make Safari’s search banners default to Contains instead of Starts With
  defaults write -app "Safari" FindOnPageMatchesWordStartsOnly -bool "false"

  # Enable the Develop menu and the Web Inspector in Safari
  defaults write -app "Safari" IncludeDevelopMenu -bool "true"
  defaults write -app "Safari" WebKitDeveloperExtrasEnabledPreferenceKey -bool "true"
  defaults write -app "Safari" com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool "true"

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool "true"

  # Enable continuous spellchecking
  defaults write -app "Safari" WebContinuousSpellCheckingEnabled -bool "true"

  # Warn about fraudulent websites
  defaults write -app "Safari" WarnAboutFraudulentWebsites -bool "true"

  # Block pop-up windows
  defaults write -app "Safari" WebKitJavaScriptCanOpenWindowsAutomatically -bool "false"
  defaults write -app "Safari" com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool "false"

  # Disable auto-playing video
  # defaults write -app "Safari" WebKitMediaPlaybackAllowsInline -bool "false"
  # defaults write -app "Safari" com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool "false"

  # Enable “Do Not Track”
  defaults write -app "Safari" SendDoNotTrackHTTPHeader -bool "true"

  # Update extensions automatically
  defaults write -app "Safari" InstallExtensionUpdatesAutomatically -bool "true"

  ###############################################################################
  # Mail                                                                        #
  ###############################################################################

  # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
  defaults write -app "Mail" NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

  # Display emails in threaded mode, sorted by date (oldest at the top)
  defaults write -app "Mail" DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -bool "true"
  defaults write -app "Mail" DraftsViewerAttributes -dict-add "SortedDescending" -bool "true"
  defaults write -app "Mail" DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

  # Disable inline attachments (just show the icons)
  defaults write -app "Mail" DisableInlineAttachmentViewing -bool "true"



  ###############################################################################
  # Activity Monitor                                                            #
  ###############################################################################

  # Show the main window when launching Activity Monitor
  defaults write -app "Activity Monitor" OpenMainWindow -bool "true"

  # Visualize CPU usage in the Activity Monitor Dock icon
  defaults write -app "Activity Monitor" IconType -int 5

  # Show all processes in Activity Monitor
  defaults write -app "Activity Monitor" ShowCategory -int 100

  # Sort Activity Monitor results by CPU usage
  defaults write -app "Activity Monitor" SortColumn -string "CPUUsage"
  defaults write -app "Activity Monitor" SortDirection -int 0

  ###############################################################################
  # TextEdit and Disk Utility                                                   #
  ###############################################################################

  # Use plain text mode for new TextEdit documents
  defaults write -app "TextEdit" RichText -int 0

  # Open and save files as UTF-8 in TextEdit
  defaults write -app "TextEdit" PlainTextEncoding -int 4
  defaults write -app "TextEdit" PlainTextEncodingForWrite -int 4

  # Enable the debug menu in Disk Utility
  defaults write -app "Disk Utility" DUDebugMenuEnabled -bool "true"
  defaults write -app "Disk Utility" advanced-image-options -bool "true"

  defaults write com.apple.commerce AutoUpdateRestartRequired -bool "true"

  ###############################################################################
  # Photos                                                                      #
  ###############################################################################

  # Prevent Photos from opening automatically when devices are plugged in
  defaults -currentHost write -app "Image Capture" disableHotPlug -bool "true"

  ###############################################################################
  # Google Chrome                                   #
  ###############################################################################

  # Use the system-native print preview dialog
  defaults write -app "Google Chrome" DisablePrintPreview -bool "true"

  # Expand the print dialog by default
  defaults write -app "Google Chrome" PMPrintingExpandedStateForPrint2 -bool "true"

  ###############################################################################
  # Kill affected applications                                                  #
  ###############################################################################

  for app (
    "Activity Monitor"
    "App Store"
    "cfprefsd"
    "Disk Utility"
    "Dock"
    "Finder"
    "Google Chrome"
    "Image Capture"
    "Mail"
    "Photos"
    "Safari"
    "SystemUIServer"
    "Terminal"
    "TextEdit"
    "Time Machine"
  ); do
    killall "$app" &>/dev/null
  done

  logger "success" "Successfully set macOS defaults. Note that some changes require a logout/restart to take effect."
}
