#!/bin/sh

openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in 'fastlane/profiles/educscie71immapp_AppStore.mobileprovision' -out 'fastlane/profiles/educscie71immapp_AppStore.mobileprovision.enc' -a
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in 'fastlane/profiles/educscie71immapp_AdHoc.mobileprovision' -out 'fastlane/profiles/educscie71immapp_AdHoc.mobileprovision.enc' -a
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in fastlane/certs/ios_development.cer -out fastlane/certs/ios_development.cer.enc -a
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in fastlane/certs/ios_distribution.cer -out fastlane/certs/ios_distribution.cer.enc -a
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in fastlane/certs/ios_distribution.p12 -out fastlane/certs/ios_distribution.p12.enc -a
