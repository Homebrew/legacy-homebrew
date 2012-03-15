require 'formula'

class Intltool < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/intltool'
  url 'http://launchpad.net/intltool/trunk/0.50.0/+download/intltool-0.50.0.tar.gz'
  md5 '0da9847a60391ca653df35123b1f7cc0'

  # Even though this module is supposed to be there on Snow Leopard,
  # I've run into a situation where it isn't, and we have gotten other
  # reports of it happening. So, adding it here just to be safe.
  # @adamv
  depends_on 'XML::Parser' => :perl

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
