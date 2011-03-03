require 'formula'

class Parrot <Formula
  head 'git://github.com/parrot/parrot.git'
  url 'ftp://ftp.parrot.org/pub/parrot/releases/supported/3.0.0/parrot-3.0.0.tar.gz'
  md5 'fc1d88114636eff4fe7953de456cecfa'
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
