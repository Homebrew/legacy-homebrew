require 'formula'

class PhpMemcache <Formula
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  homepage 'http://pecl.php.net/package/memcache'
  md5 '9542f1886b72ffbcb039a5c21796fe8a'

  depends_on 'memcached'

  def install
    Dir.chdir "memcache-#{version}" do
      # For Zend Server compatibility
      ENV.universal_binary

      system "phpize"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--enable-memcache"
      system "make"
      prefix.install 'modules/memcache.so'
    end
  end

  def caveats; <<-EOS.undent
    To use this software:
    * Add the following line to php.ini:
      zend_extension="#{prefix}/memcache.so"
    * Restart your webserver.
    * Write a PHP page that calls "phpinfo();"
    * Load it in a browser and look for the info on the memcache module.
    * If you see it, you have been successful!
    EOS
  end
end
