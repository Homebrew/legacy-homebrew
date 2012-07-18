require 'formula'

class Libogg < Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz'
  md5 '0a7eb40b86ac050db3a789ab65fe21c2'

  head 'http://svn.xiph.org/trunk/ogg'

  if ARGV.build_head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
