require 'formula'

class Abnfgen < Formula
  url 'http://www.quut.com/abnfgen/abnfgen-0.16.tar.gz'
  homepage 'http://www.quut.com/abnfgen/'
  md5 '2184310e276e15e65f8f477ca3719e08'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
