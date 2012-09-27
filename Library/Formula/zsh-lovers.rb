require 'formula'

class ZshLovers < Formula
  url 'http://grml.org/zsh/zsh-lovers.1'
  homepage 'http://grml.org/zsh/#zshlovers'
  sha1 'a080ac915acd0239690fb6ad1eed35422f1424aa'
  version '0.8.3'

  def install
    man1.install 'zsh-lovers.1'
  end
end
