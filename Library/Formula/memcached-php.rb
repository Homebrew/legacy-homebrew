require 'formula'

class MemcachedPhp < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-1.0.2.tgz'
  md5 'b91f815ad59086d0c3564cce022b5c4f'
  head 'https://github.com/php-memcached-dev/php-memcached.git', :using => :git, :branch => 'master'

  depends_on 'libmemcached'

  def install
    if ARGV.build_head? == false
      cd "memcached-#{version}"
    end

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                            "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    system "make"
    prefix.install 'modules/memcached.so'
  end

  def caveats; <<-EOS.undent
    To finish installing memcached:
      * Add the following line to php.ini:
        extension="#{prefix}/memcached.so"
      * Restart your webserver
    EOS
  end
end
