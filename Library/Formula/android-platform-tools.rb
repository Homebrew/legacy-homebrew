class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  # the url is from:
  # https://dl.google.com/android/repository/repository-10.xml
  url "https://dl.google.com/android/repository/platform-tools_r22-macosx.zip"
  version "22.0.0"
  sha256 "c06721ff66a1a3f70e489325f06474e28cd0efd5352f097ee2ff58167b4f6564"

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
