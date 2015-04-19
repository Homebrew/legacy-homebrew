require 'formula'

class TmuxCssh < Formula
  version "1.0.6-0"
  homepage 'https://github.com/dennishafemann/tmux-cssh'
  url 'https://github.com/dennishafemann/tmux-cssh/archive/1.0.6-0.tar.gz'
  sha1 '1c5dd181b9525766cc21b317c68c34cd69324b95'

  depends_on 'tmux'

  def install
    bin.install 'tmux-cssh'
  end

  test do
    system "#{bin}/tmux-cssh", "--help"
  end

end
