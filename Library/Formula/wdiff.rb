require 'formula'

class Wdiff < Formula
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.1.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.1.0.tar.gz'
  homepage 'http://www.gnu.org/software/wdiff/'
  md5 'aa4dd87a9140a96ee85d2502673d19f3'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
