require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.5.tar.gz'
  sha1 'fbe19653b65bec4670eda2e95d934eab2e5d4e45'

  head 'http://git.suckless.org/tabbed'

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
