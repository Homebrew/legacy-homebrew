require 'formula'

class Libtomcrypt < Formula
  homepage 'http://libtom.org/?page=features&whatfile=crypt'
  url 'http://libtom.org/files/crypt-1.17.tar.bz2'
  sha256 'e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116'

  bottle do
    cellar :any
    sha1 "3ffbfb0eff2dd0c6cb8d6a14c69cf14aec93ccf2" => :mavericks
    sha1 "018b39f5c06a418ee09e95bbf2da4e22a92a0b19" => :mountain_lion
    sha1 "f85f1cd5b33cde3c2ef57165bbc6763e1a839a5f" => :lion
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
