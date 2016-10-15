require 'formula'

class RbenvCommunalGems < Formula
  homepage 'https://github.com/tpope/rbenv-communal-gems'
  url 'https://github.com/tpope/rbenv-communal-gems/archive/v1.0.1.tar.gz'
  sha1 '39360238e89f2d723409c3de2a4132f561de7bb9'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
