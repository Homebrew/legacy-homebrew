require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2'
  mirror 'ftp://ftp.gmplib.org/pub/gmp/gmp-6.0.0a.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2'
  sha1 '360802e3541a3da08ab4b55268c80f799939fddc'

  bottle do
    cellar :any
    sha1 "bfaab8c533af804d4317730f62164b9c80f84f24" => :mavericks
    sha1 "99dc6539860a9a8d3eb1ac68d5b9434acfb2d846" => :mountain_lion
    sha1 "466b7549553bf0e8f14ab018bd89c48cbd29a379" => :lion
  end

  option '32-bit'
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      args << "ABI=32"
      # https://github.com/Homebrew/homebrew/issues/20693
      args << "--disable-assembly"
    elsif build.bottle?
      args << "--disable-assembly"
    end

    system "./configure", *args
    system "make"
    system "make check"
    ENV.deparallelize
    system "make install"
  end
end
