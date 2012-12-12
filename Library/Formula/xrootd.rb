require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.2.6/xrootd-3.2.6.tar.gz'
  sha1 '2eb2fc1d5b19d8080edb716bfa37469e54e5cde4'

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
