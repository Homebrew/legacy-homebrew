require 'brewkit'

class Taglib <Formula
  @url='http://developer.kde.org/~wheeler/files/src/taglib-1.5.tar.gz'
  @md5='7b557dde7425c6deb7bbedd65b4f2717'
  @homepage='http://developer.kde.org/~wheeler/taglib.html'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end