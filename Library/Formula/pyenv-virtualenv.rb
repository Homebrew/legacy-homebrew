require 'formula'

class PyenvVirtualenv < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenv'
  url 'https://github.com/yyuu/pyenv-virtualenv/archive/v20140110.1.tar.gz'
  sha1 '56e4823b13e00d17c2d73eb8e0c3e5eddc7e3d51'

  head 'https://github.com/yyuu/pyenv-virtualenv.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
