require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.96.tar.gz'
  sha1 '02339c604c840f24b66523c9faad6ed82500eda1'
  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def patches
    # Pending new tag: https://github.com/carsomyr/rbenv-bundler/issues/38
    "https://github.com/carsomyr/rbenv-bundler/commit/0aebf2.patch"
  end

  def install
    prefix.install Dir['*']
  end
end
