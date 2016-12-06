require 'formula'

class TmuxMacosxPasteboard < Formula
  head 'git://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git', :tag => "dadea0aa48259c704d0b412b9588de2f5623e323"
  homepage 'https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/blob/master/README.md'

  def install
    system "make reattach-to-user-namespace"
    bin.install ["reattach-to-user-namespace"]
  end

  def caveats; <<-EOS.undent
    In your tmux config (typically ~/.tmux.conf):
      set-option -g default-command "reattach-to-user-namespace -l zsh"

    Kill your tmux server(s) or source your tmux config
    EOS
  end
end
