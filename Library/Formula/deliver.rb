require 'formula'

class Deliver < Formula
  homepage 'https://github.com/gerhard/deliver'
  url 'https://github.com/gerhard/deliver/tarball/v0.5.0'
  sha256 '0deaea812b7c1e9ab5cfa1742c328ec68edefa9cd4d396800d2b7293a78f84af'

  head 'https://github.com/gerhard/deliver.git'

  def install
    bin.install "bin/deliver"
    prefix.install %w[libexec strategies]
    man1.install "man/deliver.1"
  end
end
