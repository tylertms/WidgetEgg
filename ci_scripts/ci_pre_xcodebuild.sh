#!/bin/sh

#  ci_pre_xcodebuild.sh.sh
#  WidgetEgg
#
#  Created by Tyler on 6/12/24.
#

if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

EXT_PLIST_PATH="${SRCROOT}/WidgetEgg/ExtensionInfo.plist"

echo "BUNDLING WITH KEY $KEY"

cat > "$EXT_PLIST_PATH" << EOF
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
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.widgetkit-extension</string>
	</dict>
</dict>
</plist>
EOF

echo "EXT PLIST CREATED AT $EXT_PLIST_PATH"
