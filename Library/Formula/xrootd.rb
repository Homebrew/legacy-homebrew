require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/index.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.3.3/xrootd-3.3.3.tar.gz'
  sha1 '087905489dda62536755a765b9296f0c7f37c149'

  depends_on 'cmake' => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
    share.install prefix/"man" # Put man pages in correct place
  end

  def test
    system "#{bin}/xrootd"
  end
end
