require "formula"

class AndroidPlatformTools < Formula
  homepage "http://developer.android.com/sdk"
  # the url is from:
  # http://dl-ssl.google.com/android/repository/repository-8.xml
  url "http://dl-ssl.google.com/android/repository/platform-tools_r20-macosx.zip"
  version '20.0.0'
  sha1 "f2c65c58caf76169d9bebf25eef5c69ff99670b5"

  conflicts_with 'android-sdk',
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
