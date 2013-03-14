require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.2.7/xrootd-3.2.7.tar.gz'
  sha1 '33c7cb60ac69dfabd76d1f0f58253a6b0533e2bd'

  depends_on 'cmake' => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  def test
    system "#{bin}/xrootd"
  end
end
