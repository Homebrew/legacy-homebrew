require 'formula'

class Libogg < Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz'
  sha1 'a900af21b6d7db1c7aa74eb0c39589ed9db991b8'

  head 'http://svn.xiph.org/trunk/ogg'

  option :universal

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
