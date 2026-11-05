#!/bin/sh
# Apply app and macOS settings with `defaults write`. Re-runs whenever this
# file changes. Apps read these at launch, so restart a running app to pick
# up a change.
set -eu

# Scroll Reverser: reverse scrolling, and show the extra options for
# scroll wheels with discrete steps. Per-device and per-axis choices are
# left at the app's defaults, which is why they aren't set here.
defaults write com.pilotmoon.scroll-reverser InvertScrollingOn -bool true
defaults write com.pilotmoon.scroll-reverser ShowDiscreteScrollOptions -bool true

# Finder Quick Actions: macOS registers new ones switched off. Turn on
# "Open in VS Code" for the right-click menu, Quick Actions, and Services.
defaults write pbs NSServicesStatus -dict-add \
  '"(null) - Open in VS Code - runWorkflowAsService"' \
  '<dict><key>presentation_modes</key><dict>
     <key>ContextMenu</key><true/>
     <key>FinderPreview</key><true/>
     <key>ServicesMenu</key><true/>
     <key>TouchBar</key><false/>
   </dict></dict>'
/System/Library/CoreServices/pbs -update
