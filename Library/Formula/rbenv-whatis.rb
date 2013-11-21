require 'formula'

class RbenvWhatis < Formula
  homepage 'https://github.com/rkh/rbenv-whatis'
  url 'https://github.com/rkh/rbenv-whatis/archive/9bf9f2.tar.gz'
  sha1 'a78eb1ce44974d7080087f96d8b17f1334b9e03c'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
