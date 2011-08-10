require 'formula'

class Povray < Formula
  url 'http://www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.1.tar.bz2'
  homepage 'http://www.povray.org/'
  md5 'b5789bb7eeaed0809c5c82d0efda571d'

  depends_on 'libtiff' => :optional
  depends_on 'jpeg' => :optional

  fails_with_llvm "llvm-gcc: povray fails with 'terminate called after throwing an instance of int'"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "COMPILED_BY=homebrew",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
