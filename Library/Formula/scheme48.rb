require 'formula'

class Scheme48 < Formula
  homepage 'http://www.s48.org/'
  url 'http://s48.org/1.9.2/scheme48-1.9.2.tgz'
  sha1 'b2d02b6ddac56e566d170b9c916f11dbd182390a'

  bottle do
    sha1 "c2d1d64385b004856a2bf1e1683f49ba339c8046" => :mavericks
    sha1 "75692a9d2fdb41ffb11f05c1be298eb33143724b" => :mountain_lion
    sha1 "061274969680e03b26a5c2c44719a41fa417ff74" => :lion
  end

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
