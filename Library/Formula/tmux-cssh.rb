require 'formula'

class TmuxCssh < Formula
  homepage 'https://github.com/dennishafemann/tmux-cssh'
  url 'https://github.com/dennishafemann/tmux-cssh/archive/0.1.tar.gz'
  sha1 '477a9079775ce48afe0c90699fa69f368e69cdfd'

  depends_on 'tmux'

  def install
    bin.install 'tmux-cssh'
  end

  test do
    system "#{bin}/tmux-cssh", "--help"
  end

end
