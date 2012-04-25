require 'formula'

class Fcgiwrap < Formula
  homepage 'http://nginx.localdomain.pl/wiki/FcgiWrap'
  url 'https://github.com/downloads/gnosek/fcgiwrap/fcgiwrap-1.0.3.tar.gz'
  md5 'be73d90df7c4442084463e2815fc213d'

  depends_on 'autoconf' => :build
  depends_on 'fcgi'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
