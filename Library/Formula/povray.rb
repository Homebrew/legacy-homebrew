require 'formula'

class Povray <Formula
  url 'http://www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.1.tar.bz2'
  homepage 'http://www.povray.org/'
  md5 'b5789bb7eeaed0809c5c82d0efda571d'

  def install
    fails_with_llvm "llvm-gcc: povray fails with 'terminate called after throwing an instance of int'"

    system "./configure", "COMPILED_BY=homebrew", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
