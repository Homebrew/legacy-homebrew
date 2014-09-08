require 'formula'

class Ext4fuse < Formula
  homepage 'https://github.com/gerard/ext4fuse'
  url 'https://github.com/gerard/ext4fuse/archive/v0.1.3.tar.gz'
  sha1 '87d436581fea73273d83779021a7a3c0158d7c41'

  head 'https://github.com/gerard/ext4fuse.git'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def install
    system 'make'
    bin.install 'ext4fuse'
  end
end
