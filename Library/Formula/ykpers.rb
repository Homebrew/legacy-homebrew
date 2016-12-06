require 'formula'

class Ykpers <Formula
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.4.1.tar.gz'
  homepage 'http://code.google.com/p/yubikey-personalization/'
  md5 'd0e75bc020d8efefbf0cf18df23a7219'

  depends_on 'libyubikey'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
