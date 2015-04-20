require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gibo'
  url 'https://github.com/simonwhitaker/gibo/archive/1.0.4.tar.gz'
  sha1 'cfc35fcf393ce3276fd6e9eed2ffc4f8d46e2f6e'

  def install
    bin.install "gibo"
    bash_completion.install 'gibo-completion.bash'
    zsh_completion.install 'gibo-completion.zsh' => '_gibo'
  end
end
