require 'formula'

class Libcue < Formula
  url 'http://downloads.sourceforge.net/project/libcue/libcue/1.4.0/libcue-1.4.0.tar.bz2'
  homepage 'http://sourceforge.net/projects/libcue/'
  sha1 '3fd31f2da7c0e3967d5f56363f3051a85a8fd50d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
