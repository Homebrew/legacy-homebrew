require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.1.0.tar.bz2'
  sha1 '231af70b7567a753b49df4216743010c193884b7'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
