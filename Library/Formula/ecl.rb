require 'formula'

class Ecl < Formula
  homepage 'http://ecls.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ecls/ecls/13.5/ecl-13.5.1.tgz'
  sha1 'db7f732e5e12182118f00c02d8d2531f6d6aefb2'

  fails_with :clang do
    cause "The built-in gmp library fails to build with clang"
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-unicode"
    system "make"
    system "make install"
  end
end
