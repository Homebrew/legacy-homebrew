require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.6.tar.gz'
  sha1 '3c64d79817337f86f0cdd60b5b79af7e77d4a5f9'

  head 'http://git.suckless.org/tabbed'

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
