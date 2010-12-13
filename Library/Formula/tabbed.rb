require 'formula'

class Tabbed <Formula
  url 'http://dl.suckless.org/tools/tabbed-0.3.tar.gz'
  homepage 'http://tools.suckless.org/tabbed'
  md5 '4a30458f9adc38db549f735b8fb6451b'
  head 'http://hg.suckless.org/tabbed'

  def install
    inreplace 'config.mk', 'LIBS = -L/usr/lib -lc -lX11', 'LIBS = -L/usr/X11/lib -lc -lX11'
    inreplace 'tabbed.1', 'new surf-window.', 'new xterm-window.'
    inreplace 'config.def.h',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "surf", "-e", winid, NULL} } },',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "xterm", "-into", winid, NULL} } },'
    system "make  PREFIX=#{prefix} install"
  end
end
