require 'formula'

class McryptPhp < Formula
  homepage 'http://php.net/manual/fr/book.mcrypt.php'
  url 'http://us.php.net/get/php-5.3.6.tar.gz/from/fr.php.net/mirror'
  version '5.3.6'
  md5 '88a2b00047bc53afbbbdf10ebe28a57e'

  depends_on 'mcrypt'

  def install
    cd "ext/mcrypt" do
      system "phpize"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-mcrypt=#{Formula.factory('mcrypt').prefix}"
      system "make"
      prefix.install 'modules/mcrypt.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish mcrypt-php installation, you need to add the
    following line into php.ini:
      extension="#{prefix}/mcrypt.so"
    Then, restart your webserver and check in phpinfo if
    you're able to see something about mcrypt
    EOS
  end
end
