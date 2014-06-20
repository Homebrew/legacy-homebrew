require 'formula'

class Scheme48 < Formula
  homepage 'http://www.s48.org/'
  url 'http://s48.org/1.9.1/scheme48-1.9.1.tgz'
  sha1 'dfc5f58b2e175216aa850910c761238774c1b7b1'

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
