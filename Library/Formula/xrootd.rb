require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.3.4/xrootd-3.3.4.tar.gz'
  sha1 '9992c80b77cababf6fe1ee8535c930d082f501b4'

  depends_on 'cmake' => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
    share.install prefix/'man'
  end

  def test
    system "#{bin}/xrootd"
  end
end
