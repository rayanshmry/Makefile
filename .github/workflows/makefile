name: Build MoustacheMod

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: theos/theos:latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build Tweak
        run: |
          make clean
          make package
          
      - name: Upload .deb Package
        uses: actions/upload-artifact@v4
        with:
          name: MoustacheMod-Package
          path: packages/*.deb
