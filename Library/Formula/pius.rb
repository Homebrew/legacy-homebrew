require 'formula'

class Pius < Formula
  homepage 'http://www.phildev.net/pius/'
  url 'http://downloads.sourceforge.net/project/pgpius/pius/2.0.9/pius-2.0.9.tar.bz2'
  sha1 'c8ecdf74b3f704a29f828fdbe0575eb247e21524'

  depends_on 'gnupg'

  def install
    bin.install 'pius'
    bin.install 'pius-keyring-mgr'
    bin.install 'pius-party-worksheet'
  end
end
