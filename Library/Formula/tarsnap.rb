require 'formula'

class Tarsnap < Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.30.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 'ad663922064a98bce9c085a53ecd83eb839457b49d7cd22cff7c069e9b7e522e'

  depends_on 'lzma' => :optional

  fails_with_llvm "Compilation hangs."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end
