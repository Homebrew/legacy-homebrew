require 'formula'

class AutopanoSiftC < Formula
  homepage 'http://wiki.panotools.org/Autopano-sift-C'
  url 'http://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fhugin%2Ffiles%2Fautopano-sift-C%2Fautopano-sift-C-2.5.1%2F'
  sha1 'f8c5f4004ae51cb58acc5cedb065ae0ef3e19a8c'
  version '2.5.1'

  depends_on 'libpano'
  depends_on 'cmake' => :install

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "/usr/local/Cellar/autopano-sift-c/2.5.1/bin/autopano-sift-c | grep 'Version 2.5.1 for hugin 0.7'"
  end
end
