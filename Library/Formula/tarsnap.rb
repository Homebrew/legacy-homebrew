require 'formula'

class Tarsnap <Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.29.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 '747510459e4af0ebbb6e267c159aa019f9337d1e07bd9a94f1aa1498081b7598'

  depends_on 'lzma' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sse2"
    system "make install"
  end
end
