require 'formula'

class Uriparser < Formula
  homepage 'http://uriparser.sourceforge.net/'
  url 'http://sourceforge.net/projects/uriparser/files/Sources/0.7.7/uriparser-0.7.7.tar.bz2'
  sha1 '160c1e6102a56efea47f257cbb261d935ae136ad'

  depends_on 'pkg-config' => :build
  depends_on 'cpptest'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make check"
    system "make install"
  end
end
