require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.1.0.tar.bz2'
  sha1 '231af70b7567a753b49df4216743010c193884b7'

  option :universal

  depends_on :libtool

  def apr_bin
    superbin or "/usr/bin"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-apr=#{apr_bin}"
    system "make install"
  end
end
