require 'formula'

class Plzip < Formula
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-1.1.tar.gz'
  sha1 '22d3bba78b9219e7976372e24773d3abc0ff4563'

  depends_on 'lzlib'

  # Stable doesn't build with clang, but 1.2-pre does
  devel do
    url 'http://download.savannah.gnu.org/releases/lzip/plzip-1.2-pre1.tar.lz'
    sha1 '2fbca2f13ff185f1e9824b8fa34ffba79fb7197f'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
