require 'formula'

class Libtomcrypt < Formula
  homepage 'http://libtom.org/?page=features&whatfile=crypt'
  url 'http://libtom.org/files/crypt-1.17.tar.bz2'
  sha256 'e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116'

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
