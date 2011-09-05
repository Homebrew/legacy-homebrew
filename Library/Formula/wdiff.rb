require 'formula'

class Wdiff < Formula
  url 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.0.0.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 '7d4836af64170150023f7424c5b82060'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
