require 'formula'

class RbenvAliases < Formula
  homepage 'https://github.com/nebhale/rbenv-aliases'
  url 'https://github.com/nebhale/rbenv-aliases/archive/v1.0.0.tar.gz'
  sha1 'c0a4b1a4f0b1931b39e3cc3969e5d37ad4dec1f9'

  head 'https://github.com/nebhale/rbenv-aliases.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
