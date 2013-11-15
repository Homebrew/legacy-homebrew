require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gibo'
  url 'https://github.com/simonwhitaker/gibo/archive/1.0.2.tar.gz'
  sha1 '54727043d837df7017ca47aeeb0274a1b3c147bf'

  def install
    bin.install "gibo"
    bash_completion.install 'gibo-completion.bash'
    zsh_completion.install 'gibo-completion.zsh' => '_gibo'
  end
end
