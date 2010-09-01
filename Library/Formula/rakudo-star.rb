require 'formula'

class RakudoStar <Formula
  url 'http://cloud.github.com/downloads/rakudo/star/rakudo-star-2010.08.tar.gz'
  homepage 'http://rakudo.org/'
  md5 'abdadbc3016498c3bd8a89b53f63ae35'

  depends_on 'parrot'

  def install
    parrot_bin = Formula.factory('parrot').bin

    system "perl Configure.pl --parrot-config=#{parrot_bin}/parrot_config"
    system "make"
    system "make install"

    bin.install "perl6"
  end
end
