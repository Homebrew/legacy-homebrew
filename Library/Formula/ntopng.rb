require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org/products/ntop/"
  url 'https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-1.2.0_r8114.tgz'

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build
  depends_on 'wget' => :build
  depends_on 'json-glib'
  depends_on 'json-c'
  depends_on 'gnutls'
  depends_on 'geoip'
  depends_on 'sqlite'
  depends_on 'rrdtool'
  depends_on 'redis'
  depends_on 'glib'
  depends_on 'zeromq'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make","install"
  end

  test do
    system "#{bin}/ntopng", "-h"
    assert_equal 0, $?.exitstatus
  end

end
