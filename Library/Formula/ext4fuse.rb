require 'formula'

class Ext4fuse < Formula
  homepage 'https://github.com/gerard/ext4fuse'
  url 'https://github.com/gerard/ext4fuse/tarball/v0.1'
  sha1 'e85e7f6aeda238d2f4b592dc2b8f106a77d47829'
  head 'https://github.com/gerard/ext4fuse.git'

  depends_on 'fuse4x'
  depends_on 'pkg-config' => :build

  def install
    system 'make'
    bin.install('ext4fuse')
  end
end
