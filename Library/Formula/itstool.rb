require 'formula'

class Itstool < Formula
  homepage 'http://itstool.org/'
  url 'http://files.itstool.org/itstool/itstool-2.0.0.tar.bz2'
  sha256 '14708111b11b4a70e240e3b404d7a58941e61dbb5caf7e18833294d654c09169'

  head do
    url 'git://gitorious.org/itstool/itstool.git'

    depends_on :autoconf
    depends_on :automake
  end

  depends_on :python
  depends_on 'libxml2'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
