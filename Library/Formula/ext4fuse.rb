require 'formula'

class Ext4fuse < Formula
  homepage 'https://github.com/gerard/ext4fuse'
  url 'https://github.com/gerard/ext4fuse/archive/v0.1.1.tar.gz'
  sha1 '1dbf4dc4859f8d118e80046cef0af2bcee471ea5'

  head 'https://github.com/gerard/ext4fuse.git'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    system 'make'
    bin.install 'ext4fuse'
  end
end
