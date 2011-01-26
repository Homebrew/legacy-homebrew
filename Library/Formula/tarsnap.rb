require 'formula'

class Tarsnap <Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.28.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 '4e36b57496a0682ec896aac753e028d9d6a34efbb23fbe2032c0e04d1be51675'

  depends_on 'lzma' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sse2"
    system "make install"
  end
end
