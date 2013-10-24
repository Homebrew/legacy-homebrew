require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.96.tar.gz'
  sha1 '02339c604c840f24b66523c9faad6ed82500eda1'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
