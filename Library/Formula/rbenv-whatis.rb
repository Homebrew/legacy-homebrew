require 'formula'

class RbenvWhatis < Formula
  homepage 'https://github.com/rkh/rbenv-whatis'
  url 'https://github.com/rkh/rbenv-whatis/archive/v1.0.0.tar.gz'
  sha1 '8c802d8e2bba66d0c87c62c9d0b887beb52b1de4'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
