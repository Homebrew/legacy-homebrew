require 'formula'

class PhpApc < Formula
  homepage 'http://pecl.php.net/package/apc'
  url 'http://pecl.php.net/get/APC-3.1.9.tgz'
  md5 'a2cf7fbf6f3a87f190d897a53260ddaa'
  version '3.1.9'
  head 'http://pecl.php.net/get/APC'

  # depends_on 'autoconf'

  def install
    if not ARGV.build_head?
      Dir.chdir "APC-#{version}"
    end

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/apc.so'
  end

  def caveats; <<-EOS.undent
     To finish installing apc-php:
       * Add the following line to #{etc}/php.ini:
         [example]
         extension="#{prefix}/apc.so"
       * Restart your webserver.
       * Write a PHP page that calls "phpinfo();"
       * Load it in a browser and look for the info on the example module.
       * If you see it, you have been successful!
     EOS
  end
end
