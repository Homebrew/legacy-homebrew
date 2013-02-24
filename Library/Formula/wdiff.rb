require 'formula'

class Wdiff < Formula
  homepage 'http://www.gnu.org/software/wdiff/'
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.1.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.1.2.tar.gz'
  sha1 '5b3ab95bd6a77fce8f194069ac0ac823593258fc'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
