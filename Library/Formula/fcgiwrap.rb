require 'formula'

class Fcgiwrap < Formula
  homepage 'http://nginx.localdomain.pl/wiki/FcgiWrap'
  url 'https://github.com/downloads/gnosek/fcgiwrap/fcgiwrap-1.0.3.tar.gz'
  sha1 'f62722efd637aea8ce4e6325c85614cfe2345d8d'

  depends_on :autoconf
  depends_on 'fcgi'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
