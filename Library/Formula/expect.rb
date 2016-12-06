require 'formula'

class Expect < Formula
  url 'http://downloads.sourceforge.net/project/expect/Expect/5.45/expect5.45.tar.gz'
  homepage 'http://expect.sourceforge.net/'
  md5 '44e1a4f4c877e9ddc5a542dfa7ecc92b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--exec_prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
