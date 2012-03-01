require 'formula'

class PspellPhp < Formula
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://museum.php.net/php5/php-5.3.6.tar.gz'
  md5 '88a2b00047bc53afbbbdf10ebe28a57e'

  depends_on 'aspell'

  def install
    cd "ext/pspell" do
      system "phpize"
      system "./configure", "--disable-debug",
                            "--prefix=#{prefix}",
                            "--with-pspell=#{HOMEBREW_PREFIX}"
      system "make"
      prefix.install 'modules/pspell.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing the pspell module:
      * Add the following line to php.ini:
        extension="#{prefix}/pspell.so"
      * To verify, run "php -m" and look for the pspell module.
      * Restart your webserver
    EOS
  end
end
