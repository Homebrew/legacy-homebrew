require 'formula'

class PyenvVirtualenv < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenv'
  url 'https://github.com/yyuu/pyenv-virtualenv/archive/v20130622.tar.gz'
  sha1 '2e27b3b76931e6f0eecc4bccb3166d1abc130393'

  head 'https://github.com/yyuu/pyenv-virtualenv.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
    ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/pyenv/plugins/#{name}"
  end
end
