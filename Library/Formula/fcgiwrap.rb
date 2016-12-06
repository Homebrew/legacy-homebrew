require 'formula'

class Fcgiwrap < Formula
  homepage 'https://github.com/gnosek/fcgiwrap'
  url 'https://github.com/downloads/gnosek/fcgiwrap/fcgiwrap-1.0.3.tar.gz'
  md5 'be73d90df7c4442084463e2815fc213d'

  depends_on 'autoconf' => :build
  depends_on 'fcgi'

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
