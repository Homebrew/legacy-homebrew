require 'formula'

class McryptPhp < Formula
  url 'http://us.php.net/get/php-5.3.6.tar.gz/from/fr.php.net/mirror'
  homepage 'http://php.net/manual/fr/book.mcrypt.php'
  md5 '88a2b00047bc53afbbbdf10ebe28a57e'
  version '5.3.6'

  depends_on 'mcrypt'

  def install
    Dir.chdir "ext/mcrypt"
    system "phpize"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/mcrypt.so'
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
