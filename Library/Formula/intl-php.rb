require 'formula'

class IntlPhp < Formula
  url 'http://us.php.net/get/php-5.3.6.tar.gz/from/fr.php.net/mirror'
  homepage 'http://www.php.net/manual/fr/book.intl.php'
  md5 '88a2b00047bc53afbbbdf10ebe28a57e'
  version '5.3.6'

  depends_on 'icu4c'

  def install
    Dir.chdir "ext/intl"
    system "phpize"
    system "./configure", "--enable-intl",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/intl.so'
  end

  def caveats; <<-EOS.undent
    To finish intl-php installation, you need to add the
    following line into php.ini:
      extension=#{prefix}/intl.so
    Then, restart your webserver and check in phpinfo if
    you're able to see something about intl
    EOS
  end
end
