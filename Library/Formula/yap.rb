require 'formula'

class Yap < Formula
  homepage 'http://www.dcc.fc.up.pt/~vsc/Yap/index.html'
  url 'http://www.dcc.fc.up.pt/~vsc/Yap/yap-6.2.2.tar.gz'
  sha1 'a02f80cac67c287645b2ced9502f5ea24a07f1c3'

  devel do
    url 'http://www.dcc.fc.up.pt/~vsc/Yap/yap-6.3.3.tar.gz'
    sha1 'd191e419e5cf74b11e003aae5fe148f3f2f26ac5'
  end

  depends_on 'gmp'
  depends_on 'readline'

  fails_with :clang do
    cause "uses variable-length arrays in structs, which will never be supported by clang"
  end

  def install
    system "./configure", "--enable-tabling",
                          "--enable-depth-limit",
                          "--enable-coroutining",
                          "--enable-threads",
                          "--enable-pthread-locking",
                          "--with-gmp=#{Formula['gmp'].opt_prefix}",
                          "--with-readline=#{Formula['readline'].opt_prefix}",
                          "--with-java=/Library/Java/Home",
                          "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  test do
    system "#{bin}/yap", "-dump-runtime-variables"
  end
end
