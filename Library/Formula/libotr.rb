require 'formula'

class Libotr < Formula
  url 'http://www.cypherpunks.ca/otr/libotr-3.2.0.tar.gz'
  homepage 'http://www.cypherpunks.ca/otr/'
  sha1 'e5e10b8ddaf59b0ada6046d156d0431cd2790db9'

  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end
