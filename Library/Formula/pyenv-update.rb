require 'formula'

class PyenvUpdate < Formula
  homepage 'https://github.com/Tacahilo/pyenv-update'
  url 'https://github.com/Tacahilo/pyenv-update/archive/v0.1.zip'
  sha1 '8411ca05314d28222139a82f48f6c6f72d2213f9'

  head 'git@github.com:Tacahilo/pyenv-update.git'

  depends_on 'pyenv'

  def install
    prefix.install Dir['*']
  end
end
