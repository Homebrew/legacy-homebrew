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
    build 421
    cause <<-EOS.undent
      Undefined symbols linking for architecture x86_64
      EOS
  end

  def install
    system "./configure",
      "--disable-debug", "--disable-dependency-tracking",
                         "--enable-tabling",
                         "--enable-depth-limit",
                         "--enable-coroutining",
                         "--enable-threads",
                         "--enable-pthread-locking",
                         "--enable-clpbn-bp=no",
                         "--with-gmp=#{Formula.factory('gmp').opt_prefix}",
                         "--with-readline=#{Formula.factory('readline').opt_prefix}",
                         "--with-java=/Library/Java/Home",
                         "--prefix=#{prefix}"

    inreplace 'Makefile' do |s|
      s.gsub! /-DMYDDAS_ODBC/, ''
    end

    system "make"
    system "make install"
  end

  def test
    system "yap -dump-runtime-variables"
  end
end
