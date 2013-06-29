require 'formula'

class Xstow < Formula
  homepage 'http://xstow.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xstow/xstow-1.0.0.tar.bz2'
  sha1 'e4e68fbf05150067d82ce526cb784c5c91107ec9'

  fails_with :clang do
    build 421
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
