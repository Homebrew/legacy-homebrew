require 'formula'

class Privoxy < Formula
  homepage 'http://www.privoxy.org'
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.19%20%28stable%29/privoxy-3.0.19-stable-src.tar.gz'
  sha1 'a82287cbf48375ef449d021473a366baeca49250'

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy"
    system "make"
    system "make install"
  end
end
