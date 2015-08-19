class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  # the url is from:
  # https://dl.google.com/android/repository/repository-10.xml
  url "https://dl.google.com/android/repository/platform-tools_r23-macosx.zip"
  version "23.0.0"
  sha256 "a5ed48f56f784fcba35e3650c001fff49de75d3631d2fc2c83479a9ebaa92724"

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
