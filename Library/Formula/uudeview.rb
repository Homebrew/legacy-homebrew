require 'formula'

class Uudeview < Formula
  homepage 'http://www.fpx.de/fp/Software/UUDeview/'
  url 'http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz'
  sha1 '2c6ab7d355b545218bd0877d598bd5327d9fd125'

  fails_with :clang do
    build 318
    cause "inews.c:195:4: error: non-void function 'append_signature' should return a value [-Wreturn-type]"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-tcl"
    system "make install"
  end

  def test
    system "#{bin}/uudeview", "-V"
  end
end
