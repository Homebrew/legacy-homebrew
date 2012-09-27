require 'formula'

class Parrot < Formula
  homepage 'http://www.parrot.org/'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/4.6.0/parrot-4.6.0.tar.bz2'
  sha256 '31d48e348eab418d5d9d9f9bb24d628763ff90c608d21b1944c227b6938a69d1'

  devel do
    url 'ftp://ftp.parrot.org/pub/parrot/releases/devel/4.7.0/parrot-4.7.0.tar.bz2'
    sha256 '4360ac3dffafffaa00bce561c1329df8ad134019f76930cf24e7a875a4422a90'
  end

  head 'https://github.com/parrot/parrot.git'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/'VERSION'
  end
end
