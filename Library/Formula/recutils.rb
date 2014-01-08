require 'formula'

class Recutils < Formula
  homepage 'http://www.gnu.org/software/recutils/'
  url 'http://ftpmirror.gnu.org/recutils/recutils-1.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/recutils/recutils-1.6.tar.gz'
  sha1 'dd7ac31ff0f8f519c4bac06613faa1ec775145ba'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
