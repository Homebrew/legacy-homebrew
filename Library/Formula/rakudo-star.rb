require 'formula'

class RakudoStar <Formula
  url 'http://cloud.github.com/downloads/rakudo/star/rakudo-star-2010.07.tar.gz'
  homepage 'http://rakudo.org/'
  md5 '3be6d0f4f9d8d1143b6c25768e8a7342'

  depends_on 'parrot'

  def install
    parrot_bin = Formula.factory('parrot').bin

    system "perl Configure.pl --parrot-config=#{parrot_bin}/parrot_config"
    system "make"
    system "make install"

    bin.install "perl6"
  end
end
