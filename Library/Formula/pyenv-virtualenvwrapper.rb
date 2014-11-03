require 'formula'

class PyenvVirtualenvwrapper < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenvwrapper'
  url 'https://github.com/yyuu/pyenv-virtualenvwrapper/archive/v20140609.tar.gz'
  sha1 '76c47ceb9d72c0cfbe788313b65371f718f343fb'

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
