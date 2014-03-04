require 'formula'

class PyenvVirtualenvwrapper < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenvwrapper'
  url 'https://github.com/yyuu/pyenv-virtualenvwrapper/archive/v20140122.tar.gz'
  sha1 '7233865730c207d6e6660db906be19b88cb3ca3b'

  head 'https://github.com/yyuu/pyenv-virtualenvwrapper.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "eval \"$(pyenv init -)\" && pyenv virtualenvwrapper && pyenv virtualenvwrapper --version"
  end
end
