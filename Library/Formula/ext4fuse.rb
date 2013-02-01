require 'formula'

class Ext4fuse < Formula
  homepage 'https://github.com/gerard/ext4fuse'
  url 'https://github.com/gerard/ext4fuse/archive/v0.1.2.tar.gz'
  sha1 'ba46e5964910d7ae42447836db1c5f1cd0e7de78'

  head 'https://github.com/gerard/ext4fuse.git'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    system 'make'
    bin.install 'ext4fuse'
  end
end
