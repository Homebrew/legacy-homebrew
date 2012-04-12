require 'formula'

class Dwarf < Formula
  url 'http://dwarf-ng.googlecode.com/files/dwarf-0.2.tar.gz'
  head 'http://code.autistici.org/svn/dwarf/trunk'
  homepage 'http://code.autistici.org/trac/dwarf'
  md5 '70dce54fe268af3368b9340e3ad73142'

  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
