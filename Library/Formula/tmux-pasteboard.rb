require 'formula'

class TmuxPasteboard < Formula
  head 'git://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git'
  homepage 'https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/'

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end
end
