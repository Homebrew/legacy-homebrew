require 'formula'

class Scheme48 < Formula
  homepage 'http://www.s48.org/'
  url 'http://s48.org/1.9.2/scheme48-1.9.2.tgz'
  sha1 'b2d02b6ddac56e566d170b9c916f11dbd182390a'

  conflicts_with 'gambit-scheme', :because => 'both install `scheme-r5rs` binaries'
  conflicts_with 'scsh', :because => 'both install include/scheme48.h'

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make install"
  end
end
