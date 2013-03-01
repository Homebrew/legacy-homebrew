require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.4.tar.gz'
  sha1 '7529360b088df30b66f05aa960712f1feda46e91'

  head 'http://hg.suckless.org/tabbed'

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
