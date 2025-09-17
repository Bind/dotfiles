#!/bin/bash

free-up-space() {
    echo "this could take awhile..."
    brew update && brew upgrade && brew cleanup
    xcrun simctl delete unavailable
    rm -rf ~/Library/Developer/Xcode/Archives
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Developer/Xcode/iOS\ Device\ Logs/
}