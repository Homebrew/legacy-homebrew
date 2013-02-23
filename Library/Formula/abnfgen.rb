require 'formula'

class Abnfgen < Formula
  homepage 'http://www.quut.com/abnfgen/'
  url 'http://www.quut.com/abnfgen/abnfgen-0.16.tar.gz'
  sha1 '0ed2d09fc1601bb22bcd452000c2e4fd9b2bff81'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
