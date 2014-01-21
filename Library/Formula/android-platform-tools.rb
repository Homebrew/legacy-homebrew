require "formula"

class AndroidPlatformTools < Formula
  homepage "http://developer.android.com/sdk"
  # the url doesn't appear on the homepage, but in
  # http://dl-ssl.google.com/android/repository/repository-8.xml
  url "http://dl-ssl.google.com/android/repository/platform-tools_r19.0.1-macosx.zip"
  version '19.0.1'
  sha1 "340a497e4199d076ea93d4ee0e7a50858344d176"

  conflicts_with 'android-sdk',
    :because => "the adb and fastboot binaries are already part of the Android SDK."

  def install
    bin.install "adb", "fastboot"
  end

end
