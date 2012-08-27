require 'formula'

class Darner < Formula
  homepage 'https://github.com/wavii/darner'
  url 'https://github.com/wavii/darner/tarball/v0.1.4'
  sha1 '721e31ea843047536fb265eaca70ddc592d14f43'

  head 'https://github.com/wavii/darner.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'snappy'
  depends_on 'leveldb'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
