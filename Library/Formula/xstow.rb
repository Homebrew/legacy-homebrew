require 'formula'

class Xstow < Formula
  homepage 'http://xstow.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/xstow/xstow-1.0.2.tar.bz2'
  sha1 '3b11025d4ec7b673ab149de6537059800816b4ed'

  fails_with :clang do
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

  test do
    system "#{bin}/xstow", "-Version"
  end
end
