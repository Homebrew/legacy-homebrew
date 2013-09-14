require 'formula'

class AdbFastboot < Formula
  homepage 'http://code.google.com/p/adb-fastboot-install/'
  url 'http://adb-fastboot-install.googlecode.com/files/Androidv4.zip'
  sha1 'ae33d44396f6684459b4bbf2e0cf264322b93f3f'

  conflicts_with 'android-sdk',
      :because => "the adb and fastboot binaries are already part of the Android SDK."

  def install
    bin.install "Mac/adb_Mac" => "adb", "Mac/fastboot_Mac" => "fastboot"
  end
end
