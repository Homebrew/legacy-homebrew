require 'formula'

class RbenvBinstubs < Formula
  homepage 'https://github.com/ianheggie/rbenv-binstubs'
  url 'https://github.com/ianheggie/rbenv-binstubs/archive/1.1.tar.gz'
  sha1 '196ab69695634b06ff6f0151270c66ab7dc9da5c'

  head 'https://github.com/ianheggie/rbenv-binstubs.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
