require 'formula'

class PyenvPipRehash < Formula
  homepage 'https://github.com/yyuu/pyenv-pip-rehash'
  url 'https://github.com/yyuu/pyenv-pip-rehash/archive/v0.0.3.tar.gz'
  sha1 'c0d354c7886aed142a46dfd8cf427a7000f40896'

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
