require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org"
  url 'https://svn.ntop.org/svn/ntop/tags/ntopng-1.1.4.tar.gz', :using => :curl
  sha1 "9e1297def6e103110741d08cc7f3d4f4f4bc5c7d"

  devel do
    url 'https://svn.ntop.org/svn/ntop/trunk/ntopng/'
    version "1.1.4"
  end

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
