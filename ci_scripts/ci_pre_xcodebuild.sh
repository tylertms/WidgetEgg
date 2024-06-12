#!/bin/sh

#  ci_pre_xcodebuild.sh.sh
#  WidgetEgg
#
#  Created by Tyler on 6/12/24.
#

if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

# Define the path for the plist file using the SRCROOT environment variable
PLIST_PATH="${SRCROOT}/MissionInfo/Info.plist"

echo "BUNDLING WITH KEY $KEY"

cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>LSEnvironment</key>
	<dict>
		<key>KEY</key>
		<string>$KEY</string>
		<key>MARKER</key>
		<string>$MARKER</string>
		<key>INDEX</key>
		<string>$INDEX</string>
	</dict>
</dict>
</plist>
EOF

echo "PLIST CREATED AT $PLIST_PATH"
