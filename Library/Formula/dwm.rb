require 'formula'

class Dwm < Formula
  homepage 'http://dwm.suckless.org/'
  url 'http://dl.suckless.org/dwm/dwm-6.0.tar.gz'
  sha1 '35346f873a27f219ae266594b3690407f95d06ef'

  bottle do
    cellar :any
    sha1 "3d1f85077637d227005f7c22273441ec7eb4ded1" => :mavericks
    sha1 "ef7ce38daa07fe707df2454a3ddf4701a4cebfe7" => :mountain_lion
    sha1 "29c1feef59b6c7da94b096a9452a1e402037fba3" => :lion
  end

  head 'http://git.suckless.org/dwm', :using => :git

  depends_on :x11

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with
    # the Mac OS X Log Out shortcut in the Apple menu.
    inreplace 'config.def.h',
    '{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },',
    '{ MODKEY|ControlMask,           XK_q,      quit,           {0} },'
    inreplace 'dwm.1', '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    In order to use the Mac OS X command key for dwm commands,
    change the X11 keyboard modifier map using xmodmap (1).

    e.g. by running the following command from $HOME/.xinitrc
    xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

    See also https://gist.github.com/311377 for a handful of tips and tricks
    for running dwm on Mac OS X.
    EOS
  end
end
