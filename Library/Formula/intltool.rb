require 'formula'

class Intltool < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/intltool'
  url 'http://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz'
  md5 '23fbd879118253cb99aeac067da5f591'

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
