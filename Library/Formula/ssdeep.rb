require "formula"

class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.11.1/ssdeep-2.11.1.tar.gz"
  sha256 "a632ac30fca29ad5627e1bf5fae05d9a8873e6606314922479259531e0c19608"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
