require 'formula'

class AutopanoSiftC < Formula
  AUTOPANO_SIFT_C_VERSION = '2.5.1'
  
  homepage 'http://wiki.panotools.org/Autopano-sift-C'
  url 'http://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fhugin%2Ffiles%2Fautopano-sift-C%2Fautopano-sift-C-2.5.1%2F'
  sha1 'f8c5f4004ae51cb58acc5cedb065ae0ef3e19a8c'
  version AUTOPANO_SIFT_C_VERSION

  depends_on 'libpano'
  depends_on 'cmake' => :install

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/autopano-sift-c/#{AUTOPANO_SIFT_C_VERSION}/bin/autopano-sift-c | grep 'Version #{AUTOPANO_SIFT_C_VERSION} for hugin 0.7'"
  end
end
