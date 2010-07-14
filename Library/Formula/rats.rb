require 'formula'

class Rats < Formula
  url 'http://www.fortify.com/servlet/download/public/rats-2.3.tar.gz'
  homepage 'http://www.fortify.com/security-resources/rats.jsp'
  md5 '339ebe60fc61789808a457f6f967d226'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
