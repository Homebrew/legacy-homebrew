require 'formula'

class Tabbed < Formula
  url 'http://dl.suckless.org/tools/tabbed-0.3.tar.gz'
  homepage 'http://tools.suckless.org/tabbed'
  sha1 '6f2e153d66be969caf5f31bc18567c75ef902269'
  head 'http://hg.suckless.org/tabbed'

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11', 'LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    inreplace 'tabbed.1', 'new surf-window.', 'new xterm-window.'
    inreplace 'config.def.h',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "surf", "-e", winid, NULL} } },',
      '{ MODKEY|ShiftMask,             XK_Return, spawn,          { .v = (char*[]){ "xterm", "-into", winid, NULL} } },'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
