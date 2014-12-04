require "formula"

class Duti < Formula
  homepage "http://duti.org/"
  head "https://github.com/moretension/duti.git"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha1 "2a4e34002db33133feb8057968d1f670bf422ea5"

  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end
