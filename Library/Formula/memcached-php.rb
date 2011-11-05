require 'formula'

class MemcachedPhp < Formula
  url 'http://pecl.php.net/get/memcached-1.0.2.tgz'
  homepage 'http://pecl.php.net/package/memcached'
  md5 'b91f815ad59086d0c3564cce022b5c4f'

  depends_on 'libmemcached'

  def install
    Dir.chdir "memcached-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/memcached.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing memcached:
      * Add the following line to php.ini:
        extension="#{prefix}/memcached.so"
      * Restart your webserver
    EOS
  end
end
