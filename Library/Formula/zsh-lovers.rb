require 'formula'

class ZshLovers < Formula
  homepage 'http://grml.org/zsh/#zshlovers'
  url 'http://grml.org/zsh/zsh-lovers.1'
  version '0.9.0'
  sha1 'bf0140e8e67ade33f2ec91ec59b5314097ee3ff4'

  def install
    man1.install 'zsh-lovers.1'
  end
end
