require 'formula'

class Privoxy < Formula
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.18%20%28stable%29/privoxy-3.0.18-stable-src.tar.gz'
  homepage 'http://www.privoxy.org'
  version '3.0.18'
  md5 'baf0b13bb591ec6e1ba15b720ddea65c'

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
