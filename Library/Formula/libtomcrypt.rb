require 'formula'

class Libtomcrypt < Formula
  homepage 'http://libtom.org/?page=features&whatfile=crypt'
  url 'http://libtom.org/files/crypt-1.17.tar.bz2'
  sha256 'e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116'

  bottle do
    cellar :any
    revision 1
    sha1 "77bfa87994a726db794bf65153913dbc2dc7aad5" => :yosemite
    sha1 "05559690a26660ed6c5979ff4661db2e57672491" => :mavericks
    sha1 "eb5270eff08703ed0d72ece429f9df5f0273fb65" => :mountain_lion
  end

  depends_on 'libtommath'

  def install
    ENV['DESTDIR'] = prefix
    ENV.append "CFLAGS", "-DLTM_DESC -DUSE_LTM"
    ENV['EXTRALIBS'] = "-ltommath"

    system "make", "library"
    include.install Dir['src/headers/*']
    lib.install 'libtomcrypt.a'
  end
end
