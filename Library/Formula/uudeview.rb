require 'formula'

class Uudeview < Formula
  homepage 'http://www.fpx.de/fp/Software/UUDeview/'
  url 'http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz'
  sha1 '2c6ab7d355b545218bd0877d598bd5327d9fd125'

  # Fix function signatures (for clang)
  def patches
    {:p0 => "https://trac.macports.org/export/102865/trunk/dports/mail/uudeview/files/inews.c.patch"}
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
