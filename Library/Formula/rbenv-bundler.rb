require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.99.tar.gz'
  sha1 '21dd20ee363d8b8c0807e659ffa2d572c67848b5'
  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
