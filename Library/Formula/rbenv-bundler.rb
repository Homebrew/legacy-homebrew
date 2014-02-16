require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0aebf227aaf45caf5dd49afbfb5d8970c1506e64.tar.gz'
  sha1 '7ecd57ec0ac461da0cbacc0518703be0c058a880'
  head 'https://github.com/carsomyr/rbenv-bundler.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
