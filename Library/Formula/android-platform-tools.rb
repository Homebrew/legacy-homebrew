class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  # the url is from:
  # https://dl.google.com/android/repository/repository-10.xml
  url "https://dl.google.com/android/repository/platform-tools_r23.0.1-macosx.zip"
  version "23.0.1"
  sha256 "d2439f5de236c3831c048b678653c5955487351be8e196c65923b4eca5c47692"

  bottle :unneeded

  depends_on :macos => :mountain_lion

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
