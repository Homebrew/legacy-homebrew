require 'formula'

class Yafc < Formula

  depends_on 'openssl'
  depends_on 'readline' 

  homepage 'http://yafc.sourceforge.net/'
  url 'http://sourceforge.net/projects/yafc/files/yafc/yafc-1.1.1/yafc-1.1.1.tar.gz'
  sha1 'f80a428845d8576f1dc6067808c80c66f6236818'

  def install
    system "./configure", "--disable-debug", "--mandir=${prefix}/share/man", 
                          "--infodir=${prefix}/share/info", "--with-readline=${prefix}", 
                          "--with-krb5=${prefix}"
  end

  test do
    system "false"
  end
end