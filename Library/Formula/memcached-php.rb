require 'formula'

class MemcachedPhp < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.0.tgz'
  md5 '4ea0226db4b9f3517b36e06d79921149'

  depends_on 'libmemcached'

  def install
    cd "memcached-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}",
                            "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
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
