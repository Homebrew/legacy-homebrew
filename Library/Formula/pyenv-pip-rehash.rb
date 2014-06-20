require 'formula'

class PyenvPipRehash < Formula
  homepage 'https://github.com/yyuu/pyenv-pip-rehash'
  url 'https://github.com/yyuu/pyenv-pip-rehash/archive/v0.0.4.tar.gz'
  sha1 'afbce380b888c987138f28d33fe1ba5a38cdb41a'

  head 'https://github.com/yyuu/pyenv-pip-rehash.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    %x(pyenv hooks exec).include?('pip.bash')
  end
end
