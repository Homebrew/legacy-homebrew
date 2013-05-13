require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'
  url 'http://fossies.org/linux/misc/fltk-1.3.2-source.tar.gz'
  sha1 '25071d6bb81cc136a449825bfd574094b48f07fb'

  option :universal

  depends_on :libpng
  depends_on 'jpeg'

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make install"
  end
end
