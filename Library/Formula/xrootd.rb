require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.2.2/xrootd-3.2.2.tar.gz'
  sha1 '349ddefbfff3d7ea900a32122b93e9362a1d5332'

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
