require 'formula'

class Intltool < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/intltool'
  url 'http://launchpad.net/intltool/trunk/0.50.0/+download/intltool-0.50.0.tar.gz'
  md5 '0da9847a60391ca653df35123b1f7cc0'

  depends_on 'XML::Parser' => :perl

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
