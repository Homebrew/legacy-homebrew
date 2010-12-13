require 'formula'

class Libotr <Formula
  url 'http://www.cypherpunks.ca/otr/libotr-3.2.0.tar.gz'
  homepage 'http://www.cypherpunks.ca/otr/'
  md5 'faba02e60f64e492838929be2272f839'

  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end
