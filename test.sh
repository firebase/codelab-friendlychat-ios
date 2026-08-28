#!/usr/bin/env bash

set -eo pipefail

EXIT_STATUS=0

if [ -d "${DIR}/FriendlyChat${LANGUAGE}.xcworkspace" ]; then
  BUILD_TARGET=(-workspace "${DIR}/FriendlyChat${LANGUAGE}.xcworkspace")
else
  BUILD_TARGET=(-project "${DIR}/FriendlyChat${LANGUAGE}.xcodeproj")
fi

(xcodebuild \
  "${BUILD_TARGET[@]}" \
  -scheme FriendlyChat${LANGUAGE} \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  build \
  ONLY_ACTIVE_ARCH=YES \
  CODE_SIGNING_REQUIRED=NO \
  | xcpretty) || EXIT_STATUS=$?

exit $EXIT_STATUS
