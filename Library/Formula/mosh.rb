require 'formula'

class Mosh <Formula
  url 'http://mosh-scheme.googlecode.com/files/mosh-0.2.6p.tar.gz'
  homepage 'http://mosh.monaos.org'
  md5 'e41e38a4a09614392c6e2eb850143724'
  version '0.2.6'

  depends_on 'gmp'
  depends_on 'oniguruma'

  def install
    fails_with_llvm
    ENV.gcc_4_2
    system "./configure", "--disable-debug", "--prefix=#{prefix}", 
           "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
