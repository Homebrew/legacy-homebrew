require 'formula'

class ZshLovers < Formula
  url 'http://grml.org/zsh/zsh-lovers.1'
  homepage 'http://grml.org/zsh/#zshlovers'
  md5 '60c8be931150f3d12d04be834e61035c'
  version '0.8.3'

  def install
    man1.install 'zsh-lovers.1'
  end
end
