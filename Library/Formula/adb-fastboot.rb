require 'formula'

class AdbFastboot < Formula
  homepage 'http://code.google.com/p/adb-fastboot-install/'
  url 'http://adb-fastboot-install.googlecode.com/files/Androidv4.zip'
  sha1 'ae33d44396f6684459b4bbf2e0cf264322b93f3f'

  def install
    File.rename "Mac/adb_Mac", "Mac/adb"
    File.rename "Mac/fastboot_Mac", "Mac/fastboot"
    bin.install "Mac/adb", "Mac/fastboot"
  end
end
