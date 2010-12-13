require 'formula'

class Libogg <Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.2.0.tar.gz'
  md5 'c95b73759acfc30712beef6ce4e88efa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
