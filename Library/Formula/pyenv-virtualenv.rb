require 'formula'

class PyenvVirtualenv < Formula
  homepage 'https://github.com/yyuu/pyenv-virtualenv'
  url 'https://github.com/yyuu/pyenv-virtualenv/archive/v20131216.tar.gz'
  sha1 '4aad09eaa441aebf81d4fd8921bca63ff16a0edc'

  head 'https://github.com/yyuu/pyenv-virtualenv.git'

  depends_on 'pyenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
    ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/pyenv/plugins/#{name}"
  end
end
