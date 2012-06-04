require 'formula'

class Wdiff < Formula
  homepage 'http://www.gnu.org/software/wdiff/'
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.1.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.1.2.tar.gz'
  md5 'ac51497a2b33094c484237049803a697'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
