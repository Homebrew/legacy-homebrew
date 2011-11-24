require 'formula'

class XmlCoreutils < Formula
  url 'http://www.lbreyer.com/gpl/xml-coreutils-0.8a.tar.gz'
  homepage 'http://www.lbreyer.com/xml-coreutils.html'
  md5 '2a5fa1f1feffad6be2f8af7661408268'

  depends_on 's-lang'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
