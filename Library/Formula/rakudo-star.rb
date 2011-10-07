require 'formula'

class RakudoStar < Formula
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2011.04.tar.gz'
  md5 '1c01a95e6fa459f8b3481da15a79b71b'
  homepage 'http://rakudo.org/'

  depends_on 'parrot'

  def install
    parrot_bin = Formula.factory('parrot').bin

    system "perl Configure.pl --parrot-config=#{parrot_bin}/parrot_config"
    system "make"
    system "make install"

    bin.install "perl6"
  end
end
