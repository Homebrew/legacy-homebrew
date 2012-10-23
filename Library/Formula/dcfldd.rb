require 'formula'

class Dcfldd < Formula
  url 'http://downloads.sourceforge.net/project/dcfldd/dcfldd/1.3.4-1/dcfldd-1.3.4-1.tar.gz'
  homepage 'http://dcfldd.sourceforge.net/'
  sha1 'fb1c55f107a6af5ef8703a44d33476e508815913'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
