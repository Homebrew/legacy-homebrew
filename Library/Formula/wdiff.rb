require 'formula'

class Wdiff < Formula
  homepage 'http://www.gnu.org/software/wdiff/'
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.1.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.1.1.tar.gz'
  md5 '2214c54f3b380e6cee622674638bc766'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
