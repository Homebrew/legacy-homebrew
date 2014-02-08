require 'formula'

class Kerl < Formula
  homepage 'https://github.com/spawngrid/kerl'
  url 'https://github.com/spawngrid/kerl/archive/f350e80171c1f4f004babe0a7186336ad7a14aa7.zip'
  version '20140201'
  sha1 '9ac26009c2b4b5f059cd5ae338db123127e390e4'

  def install
    bin.install 'kerl'
    bash_completion.install 'bash_completion/kerl'
    zsh_completion.install 'zsh_completion/_kerl'
  end
end
