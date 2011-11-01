require 'formula'

class RbenvBundler < Formula
  url 'https://github.com/carsomyr/rbenv-bundler.git',
      :tag => '97568499f4547fd30bbc6ac923442fccb100a777'
  version '97568499f4547fd30bbc6ac923442fccb100a777'
  homepage 'https://github.com/carsomyr/rbenv-bundler'

  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
