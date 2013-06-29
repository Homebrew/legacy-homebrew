require 'formula'

class Wdiff < Formula
  homepage 'http://www.gnu.org/software/wdiff/'
  url 'http://ftpmirror.gnu.org/wdiff/wdiff-1.2.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wdiff/wdiff-1.2.1.tar.gz'
  sha1 '6b5c7c97252cfe607bb1db7db148061be7259a7e'

  depends_on 'gettext' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make install"
  end
end
