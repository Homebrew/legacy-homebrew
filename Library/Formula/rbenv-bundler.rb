require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.97.tar.gz'
  sha1 'a31e0893465566db8e5c11c555b2ba0d314a869b'
  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
