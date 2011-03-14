require 'formula'

class MemcachePhp < Formula
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  homepage 'http://pecl.php.net/package/memcache'
  md5 '9542f1886b72ffbcb039a5c21796fe8a'

  def install
    Dir.chdir "memcache-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/memcache.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing memcache:
      * Add the following line to php.ini:
        extension="#{prefix}/memcache.so"
      * Restart your webserver
    EOS
  end
end
