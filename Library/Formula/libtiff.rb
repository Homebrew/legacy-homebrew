require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-3.9.5.tar.gz'
  sha256 'ecf2e30582698dbc61d269203bbd1e701a1a50fb26c87d709e10d89669badb33'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
