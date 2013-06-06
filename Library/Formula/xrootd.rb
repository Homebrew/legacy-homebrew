require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.3.2/xrootd-3.3.2.tar.gz'
  sha1 '353e7328d0d3cc7307e68a92e4778286af54284a'

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
