require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org/products/ntop/"
  url 'https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-1.2.0_r8114.tgz'
  sha1 "0d327bc6230cc8fab6350989e883406a195edb7c"
  version "1.2"

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build
  depends_on 'json-glib' => :build
  depends_on 'json-c' => :build
  depends_on 'wget' => :build
  depends_on 'rrdtool' => :build
  depends_on 'zeromq' => :build
  depends_on 'gnutls'
  depends_on 'geoip'
  depends_on 'sqlite'
  depends_on 'redis'
  depends_on 'glib'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make","install"
  end

  test do
    system "#{bin}/ntopng", "-h"
  end

end
