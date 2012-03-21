require 'formula'

class RakudoStar < Formula
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2012.01.tar.gz'
  sha256 '2bfa055c6d3b6060917fb45561d1346fef518912aaf69af361f54dd3f9ec903c'
  homepage 'http://rakudo.org/'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional

  def install
    system "perl Configure.pl --prefix=#{prefix} --gen-parrot"
    system "make"
    system "make install"
  end

  def caveats
    <<EOF
Raukdo Star comes with its own specific version of Parrot. Installing the
Parrot formula along side the Rakudo Star formula will override a number
of the binaries (eg. parrot, nqp, winxed, etc.).
EOF
  end
end
