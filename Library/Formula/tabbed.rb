require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.4.tar.gz'
  sha1 '7529360b088df30b66f05aa960712f1feda46e91'

  head 'http://hg.suckless.org/tabbed'

  depends_on :x11

  def install
<<<<<<< HEAD
<<<<<<< HEAD
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11', 'LIBS = -L#{MacOS::XQuartz.lib} -lc -lX11"
=======
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11', 'LIBS = -L#{MacOS::X11.lib} -lc -lX11"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    inreplace 'tabbed.1', 'new surf-window.', 'new xterm-window.'
    inreplace 'config.def.h',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "surf", "-e", winid, NULL} } },',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "xterm", "-into", winid, NULL} } },'
=======
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
    system "make", "PREFIX=#{prefix}", "install"
  end
end
