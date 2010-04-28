require 'formula'

class Tarsnap <Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.26.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 '426c932b7270ddd9f123d04c86bfcb5bd992ad156931a135ed38664638193fa5'

 depends_on 'lzma' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-sse2"
    system "make install"
  end
end
