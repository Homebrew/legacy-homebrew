require "formula"

class AndroidPlatformTools < Formula
  homepage "http://developer.android.com/sdk"
  # the url is from:
  # http://dl-ssl.google.com/android/repository/repository-8.xml
  url "http://dl-ssl.google.com/android/repository/platform-tools_r21-macosx.zip"
  version '21.0.0'
  sha1 "6675f9f583841972c5c5ef8d2c131e1209529fde"

  conflicts_with 'android-sdk',
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
