require 'formula'

class MemcachedPhp < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.0.tgz'
  md5 '4ea0226db4b9f3517b36e06d79921149'

  depends_on 'libmemcached'

  if ARGV.include? '--with-igbinary'
    depends_on 'igbinary-php'
  end

  def options
    [
      ['--without-session', 'Disable memcached session handler support'],
      ['--with-igbinary', 'Enable memcached igbinary serializer support'],
      ['--with-json', 'Enable memcached json serializer support'],
      ['--without-sasl', 'Disable memcached sasl support'],
    ]
  end

  def install
    cd "memcached-#{version}" do
      system "phpize"

      args = [
        "--prefix=#{prefix}",
        "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
      ]
      
      if ARGV.include? '--with-igbinary'
        args.push "--with-php-config=#{HOMEBREW_PREFIX}/bin/php-config"
        args.push "--enable-memcached-igbinary" if ARGV.include? '--with-igbinary'
      end

      args.push "--enable-memcached-json" if ARGV.include? '--with-json'
      args.push "--disable-memcached-sasl" if ARGV.include? '--without-sasl'
      args.push "--disable-memcached-session" if ARGV.include? '--without-session'    

      system "./configure", *args                          
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
