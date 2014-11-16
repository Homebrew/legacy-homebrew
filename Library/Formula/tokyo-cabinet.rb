require 'formula'

class TokyoCabinet < Formula
  homepage "http://fallabs.com/tokyocabinet/"
  url "http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "http://ftp.de.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"

  bottle do
    sha1 "17feb98432ff6345f15bc92d60a43df7188fcc0d" => :mavericks
    sha1 "d3390f329991082ba274c1f34b07a15dc6a413c3" => :mountain_lion
    sha1 "ff3403ef9b0b0bda9bc3fe21cdd12b42a141e863" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
