require 'formula'

class Parrot < Formula
  head 'https://github.com/parrot/parrot.git'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/3.6.0/parrot-3.6.0.tar.bz2'
  sha256 'a6ae5c4a1af3602043d1139a12ae9d4dfe2dd000250b1a76fc339bf4a004f8c7'
  homepage 'http://www.parrot.org/'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make install"
  end
end
