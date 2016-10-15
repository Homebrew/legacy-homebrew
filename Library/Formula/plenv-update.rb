require 'formula'

class PlenvUpdate < Formula
  homepage 'https://github.com/Tacahilo/plenv-update'
  url 'https://github.com/Tacahilo/plenv-update/archive/v0.1.2.zip'
  sha1 '9e8385f9adef71b0fc62048ecc3abda74e494865'

  head 'git@github.com:Tacahilo/plenv-update.git'

  depends_on 'plenv'

  def install
    prefix.install Dir['*']
  end
end
