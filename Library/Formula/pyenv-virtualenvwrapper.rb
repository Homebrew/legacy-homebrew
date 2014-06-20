require 'formula'

class PyenvVirtualenvwrapper < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenvwrapper'
  url 'https://github.com/yyuu/pyenv-virtualenvwrapper/archive/v20140321.tar.gz'
  sha1 '964b6a52f4c097effd03a5c3005a42dfbb413508'

  head 'https://github.com/yyuu/pyenv-virtualenvwrapper.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "eval \"$(pyenv init -)\" && pyenv virtualenvwrapper"
  end
end
