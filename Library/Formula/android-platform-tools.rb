class AndroidPlatformTools < Formula
  homepage "https://developer.android.com/sdk"
  # the url is from:
  # https://dl.google.com/android/repository/repository-8.xml
  url "https://dl.google.com/android/repository/platform-tools_r21-macosx.zip"
  version "21.0.0"
  sha256 "30ae8724da3db772a776d616b4746516f24ae81330e84315a7ce0c49e0b0b3cb"

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
