require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.12/libpng-1.5.12.tar.gz'
  sha1 'c329f3a9b720d7ae14e8205fa6e332236573704b'

  keg_only :provided_by_osx if MacOS::X11.installed?

  bottle do
    sha1 '83c6be83e86404f41982e5e1e6877924fe737bdf' => :mountainlion
    sha1 '9a86cc5cec4cb19bd04c7c1e93595d96ebcde66f' => :lion
    sha1 '3ba3f991b61afcaf0f369da89443738443d4effe' => :snowleopard
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
