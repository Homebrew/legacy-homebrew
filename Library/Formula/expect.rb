require 'formula'

class Expect < Formula
  homepage 'http://expect.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/expect/Expect/5.45/expect5.45.tar.gz'
  md5 '44e1a4f4c877e9ddc5a542dfa7ecc92b'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-tcl=/usr/lib",
                          "--with-tclinclude=/usr/include",
                          "--enable-shared"

    system "make"
    system "make install"
  end

  def test
    system "#{bin}/mkpasswd"
  end
end
