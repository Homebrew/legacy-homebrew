require 'formula'

class Celt < Formula
  homepage 'http://www.celt-codec.org/'
  url 'http://downloads.xiph.org/releases/celt/celt-0.11.1.tar.gz'
  sha256 '01c2579fba8b283c9068cb704a70a6e654aa74ced064c091cafffbe6fb1d4cbf'

  depends_on 'libogg' => :optional

  fails_with :llvm do
    build 2335
    cause "'make check' fails"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
