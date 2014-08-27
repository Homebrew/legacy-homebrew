require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.98.tar.gz'
  sha1 '12213ebf7dda33d8112a1ec55aff71c60268ca1a'
  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
