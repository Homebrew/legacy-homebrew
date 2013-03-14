require 'formula'

class ZshLovers < Formula
  homepage 'http://grml.org/zsh/#zshlovers'
  url 'http://grml.org/zsh/zsh-lovers.1'
  version '0.8.3'
  sha1 'a080ac915acd0239690fb6ad1eed35422f1424aa'

  def install
    man1.install 'zsh-lovers.1'
  end
end
