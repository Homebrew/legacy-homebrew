require 'formula'

class Pakchois < Formula
  url 'http://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz'
  homepage 'http://www.manyfish.co.uk/pakchois/'
  md5 '218ad0256e514989299acdf4e86aaf3d'

  depends_on 'opensc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-module-path=#{HOMEBREW_PREFIX}/lib/pkcs11/"
    system "make install"
  end
end
