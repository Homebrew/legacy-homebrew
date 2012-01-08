require 'formula'

class RbenvPrompt < Formula
  url 'https://github.com/joefiorini/rbenv-prompt/tarball/v0.1.0'
  homepage 'https://github.com/joefiorini/rbenv-prompt'
  md5 '49a57829303d80782581d0797de24da1'

  head 'https://github.com/joefiorini/rbenv-prompt.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
