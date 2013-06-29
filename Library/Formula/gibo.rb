require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gitignore-boilerplates'
  url 'https://github.com/simonwhitaker/gitignore-boilerplates/archive/1.0.1.tar.gz'
  sha1 'f1c232bb04c1514586fda2e60fb11ab2fcdd8ea0'

  def install
    bin.install "gibo"
    bash_completion.install 'gibo-completion.bash'
    zsh_completion.install 'gibo-completion.zsh' => '_gibo'
  end
end
