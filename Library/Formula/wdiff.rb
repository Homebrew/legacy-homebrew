require 'formula'

class Wdiff < Formula
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.0.1.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 'c3b8e48a113fd064731d7372aae782f5'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
