require 'formula'

class Privoxy < Formula
  homepage 'http://www.privoxy.org'
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.21%20%28stable%29/privoxy-3.0.21-stable-src.tar.gz'
  sha1 '2d73a9146e87218b25989096f63ab0772ce24109'

  depends_on :automake
  depends_on :libtool
  depends_on 'pcre'

  def install
    # Find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make install"
  end
end
