require 'formula'

class Parrot < Formula
  homepage 'http://www.parrot.org/'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/5.0.0/parrot-5.0.0.tar.bz2'
  sha256 '40c7176059e4462c722511a29450a4b80867a8459e273b602fbeaac2a22457f9'

  devel do
    url 'ftp://ftp.parrot.org/pub/parrot/releases/devel/5.7.0/parrot-5.7.0.tar.bz2'
    sha256 '73aacaecd81b7ef43689e9d23f641a690aabde524a2e60660d872dad82f7a337'
  end

  head 'https://github.com/parrot/parrot.git'

  conflicts_with 'rakudo-star'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional
  depends_on 'readline' => :optional
  depends_on 'libffi' => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/'VERSION'
  end
end
