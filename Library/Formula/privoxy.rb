require 'formula'

class Privoxy < Formula
  homepage 'http://www.privoxy.org'
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.19%20%28stable%29/privoxy-3.0.19-stable-src.tar.gz'
  sha1 'a82287cbf48375ef449d021473a366baeca49250'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

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
