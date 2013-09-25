require 'formula'

class RbenvBinstubs < Formula
  homepage 'https://github.com/ianheggie/rbenv-binstubs'
  url 'https://github.com/ianheggie/rbenv-binstubs/archive/1.3.tar.gz'
  sha1 '1b2beade16979309bc65a5babfbe5ddfe4763eee'

  head 'https://github.com/ianheggie/rbenv-binstubs.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
