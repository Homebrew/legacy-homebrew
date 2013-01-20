require 'formula'

class Yap < Formula
  homepage 'http://www.dcc.fc.up.pt/~vsc/Yap/index.html'
  url 'http://www.dcc.fc.up.pt/~vsc/Yap/yap-6.2.2.tar.gz'
  sha1 'a02f80cac67c287645b2ced9502f5ea24a07f1c3'

  depends_on 'gmp'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Undefined symbols linking for architecture x86_64
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-threads",
                          "--enable-pthread-locking",
                          "--enable-or-parallelism",
                          "--with-gmp=#{Formula.factory('gmp').opt_prefix}"
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "yap -dump-runtime-variables"
  end
end
