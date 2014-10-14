require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gibo'
  url 'https://github.com/simonwhitaker/gibo/archive/1.0.3.tar.gz'
  sha1 'd0d0e331558912fdfa7b8a8ac1b963bbea1388a6'

  def install
    bin.install "gibo"
    bash_completion.install 'gibo-completion.bash'
    zsh_completion.install 'gibo-completion.zsh' => '_gibo'
  end
end
