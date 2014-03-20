require 'formula'

class PyenvVirtualenv < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenv'
  url 'https://github.com/yyuu/pyenv-virtualenv/archive/v20140123.tar.gz'
  sha1 '157571744ba1a16c44a83e8a250b3bf47ac53ab3'

  head 'https://github.com/yyuu/pyenv-virtualenv.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
