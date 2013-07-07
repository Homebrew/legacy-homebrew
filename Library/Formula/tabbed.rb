require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.4.1.tar.gz'
  sha1 'f110ea52e900feb6d4f01ddcc627cf6b54aefafb'

  head 'http://hg.suckless.org/tabbed'

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
