require 'formula'

class Openlitespeed < Formula
  homepage 'http://open.litespeedtech.com/mediawiki/'
  url 'http://open.litespeedtech.com/packages/openlitespeed-1.2.9.tgz'
  sha1 'dbdfa1337caeabaca6814e2c12266f5570f14dd7'
  head 'https://github.com/litespeedtech/openlitespeed.git'

  option 'with-debug', 'Compile with support for debug log'
  option 'with-spdy', 'Compile with support for SPDY module'

  depends_on 'pcre'
  depends_on 'geoip'
  # SPDY needs openssl >= 1.0.1 for NPN; see:
  # https://tools.ietf.org/agenda/82/slides/tls-3.pdf
  # http://www.openssl.org/news/changelog.html
  depends_on 'openssl' if build.with? 'spdy'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-debug" if build.include? 'with-debug'
    args << "--enable-spdy" if build.include? 'with-spdy'
    args << "--with-openssl=#{Formula.factory('openssl').opt_prefix}" if build.include? 'with-spdy'
    system "./configure", *args
    system "make"
    system "make install"
  end
end
