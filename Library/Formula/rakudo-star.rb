require 'formula'

class RakudoStar <Formula
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2010.10.tar.gz'
  homepage 'http://rakudo.org/'
  md5 '02b426572fe2f42514940f485bcf1d91'

  depends_on 'parrot'

  def install
    parrot_bin = Formula.factory('parrot').bin

    system "perl Configure.pl --parrot-config=#{parrot_bin}/parrot_config"
    system "make"
    system "make install"

    bin.install "perl6"
  end
end
