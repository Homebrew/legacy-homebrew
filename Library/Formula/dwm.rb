require 'formula'

class Dwm < Formula
  homepage 'http://dwm.suckless.org/'
  url 'http://dl.suckless.org/dwm/dwm-6.0.tar.gz'
  sha1 '35346f873a27f219ae266594b3690407f95d06ef'

  head 'http://hg.suckless.org/dwm'

  option 'with-command-key', 'Use Mac OS X command key as modifier key'

  depends_on :x11

  def install
    inreplace 'config.def.h' do |s|
      # Remap the dwm quit keybinding from MODKEY-Shift-q
      # to MODEKY-Control-q, since the former collides with
      # the Mac OS X Log Out shortcut in the Apple menu.
      s.gsub! '{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },',
              '{ MODKEY|ControlMask,           XK_q,      quit,           {0} },'

      if build.with? 'command-key'
        s.gsub! '#define MODKEY Mod1Mask',
                '#define MODKEY Mod2Mask'
      end
    end

    # Update the manpage to reflect the above customization
    inreplace 'dwm.1' do |s|
      s.gsub! '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
      if build.with? 'command-key'
        s.gsub! 'Mod1', 'Mod2'
      end
    end

    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    In order to use the Mac OS X command key for dwm commands,
    install with the --command-key option or change the X11
    keyboard modifier map using xmodmap (1), e.g. by running
    the following command:

    xmodmap -e 'clear Mod1' -e 'clear Mod2' -e 'add Mod1 = Meta_L'

    Since the emulate 3 button mouse preference may interfere with
    the dwm modifier key use the following command to emulate mouse
    button 3 press with the FN key, see Xquartz (1) for details:

    defaults write org.macosforge.xquartz.X11 fake_button3 fn

    See also https://gist.github.com/311377 for a handful of tips and tricks
    for running dwm on Mac OS X.
    EOS
  end
end
