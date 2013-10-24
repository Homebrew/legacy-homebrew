require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gibo'
  url 'https://github.com/simonwhitaker/gibo/archive/1.0.1.tar.gz'
  sha1 '06923dcdfd8052e7cfe2d4806b51d1b78b229bfa'

  def install
    bin.install "gibo"
    bash_completion.install 'gibo-completion.bash'
    zsh_completion.install 'gibo-completion.zsh' => '_gibo'
  end
end
