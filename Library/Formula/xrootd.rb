require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.1.1/xrootd-3.1.1.tar.gz'
  md5 '6466b12a99aed3f8ea0b56b5b3ace093'

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
