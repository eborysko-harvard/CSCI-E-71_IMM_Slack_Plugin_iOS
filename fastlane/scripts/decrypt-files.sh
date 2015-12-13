#!/bin/sh

echo "=== Encrypted Files ==="
ls -lt ./certs
ls -lt ./profiles
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in 'profiles/educscie71immapp_AppStore.mobileprovision.enc' -d -a -out 'profiles/educscie71immapp_AppStore.mobileprovision'
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in 'profiles/educscie71immapp_AdHoc.mobileprovision.enc' -d -a -out 'profiles/educscie71immapp_AdHoc.mobileprovision'
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in certs/ios_development.cer.enc -d -a -out certs/ios_development.cer
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in certs/ios_distribution.cer.enc -d -a -out certs/ios_distribution.cer
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in certs/ios_distribution.p12.enc -d -a -out certs/ios_distribution.p12
echo "=== Decrypted Files ==="
ls -lt ./certs
ls -lt ./profiles

# Put the provisioning profile in place
echo "=== Moving Provisioning Profile ==="
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./profiles/educscie71immapp_AdHoc.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
cp "./profiles/educscie71immapp_AppStore.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
