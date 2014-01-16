require 'formula'

class Xstow < Formula
  homepage 'http://xstow.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xstow/xstow-1.0.1.tar.bz2'
  sha1 '2c9608ecfd591eba1e194f4673b28e0f28836741'

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      clang does not support unqualified lookups in c++ templates, see:
      http://clang.llvm.org/compatibility.html#dep_lookup
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xstow", "-Version"
  end
end
