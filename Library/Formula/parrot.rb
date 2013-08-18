require 'formula'

class Parrot < Formula
  homepage 'http://www.parrot.org/'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/5.0.0/parrot-5.0.0.tar.bz2'
  sha256 '40c7176059e4462c722511a29450a4b80867a8459e273b602fbeaac2a22457f9'

  devel do
    url 'ftp://ftp.parrot.org/pub/parrot/releases/devel/5.6.0/parrot-5.6.0.tar.bz2'
    sha256 '5cd1a7d413eee32fa9d1218b8475d810fbc7a80c4112a5590c8b060255f95fd7'
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
