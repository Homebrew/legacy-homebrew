require 'formula'

class Libogg <Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.2.2.tar.gz'
  md5 '5a9fcabc9a1b7c6f1cd75ddc78f36c56'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
