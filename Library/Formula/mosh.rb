require 'formula'

class Mosh <Formula
  url 'http://storage.osdev.info/pub/idmjt/diaryimage/1011/mosh-0.2.6rc13p.tar.gz'
  homepage 'http://mosh.monaos.org'
  md5 '99c97151d93556490245d33fac3769c2'
  version '0.2.6'

  ENV.gcc_4_2 if MACOS_VERSION < 10.6

  depends_on 'gmp'
  depends_on 'oniguruma'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
