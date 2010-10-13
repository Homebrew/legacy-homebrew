require 'formula'

class Libass <Formula
  url 'http://libass.googlecode.com/files/libass-0.9.9.tar.bz2'
  homepage 'http://code.google.com/p/libass/'
  md5 '6f545089d838d524c4f3b12e8ef6ed38'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
