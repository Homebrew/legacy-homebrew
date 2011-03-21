require 'formula'

class RakudoStar < Formula
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2011.01.tar.gz'
  md5 '3ba1e37842e17b8fb5e0b21f614a6286'
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
