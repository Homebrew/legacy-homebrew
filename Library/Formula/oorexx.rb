require 'formula'

class Oorexx < Formula
  url 'http://downloads.sourceforge.net/project/oorexx/oorexx/4.0.0/ooRexx-4.0.0.tar.gz'
  homepage 'http://www.oorexx.org/'
  md5 '938e8fbf254c9e043b92a3530a3d8f7d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
