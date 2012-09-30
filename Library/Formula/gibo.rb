require 'formula'

class Gibo < Formula
  homepage 'https://github.com/simonwhitaker/gitignore-boilerplates'
  url 'https://github.com/simonwhitaker/gitignore-boilerplates/tarball/1.0.1'
  sha1 '63b46c7ac725a25f6b9df47cebc8f798ac048b1e'

  def install
    bin.install "gibo"
    (prefix/'etc/bash_completion.d').install 'gibo-completion.bash'
    (share/'zsh/site-functions').install 'gibo-completion.zsh' => '_gibo'
  end
end
