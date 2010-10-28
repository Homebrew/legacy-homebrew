require 'formula'

class Xcache <Formula
  url 'http://xcache.lighttpd.net/pub/Releases/1.3.0/xcache-1.3.0.tar.gz'
  homepage 'http://xcache.lighttpd.net/'
  md5 'aa78eec93ce9684dfd99010f62ad6720'

  def install
    # See http://github.com/mxcl/homebrew/issues/issue/69
    ENV.universal_binary unless Hardware.is_64_bit?

    system "phpize"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/xcache.so'
  end

  def caveats; <<-EOS.undent
    To use this software:
     * Add the following line to php.ini:
        extension="#{prefix}/xcache.so"
     * Restart your webserver.
     * Write a PHP page that calls "phpinfo();"
     * Load it in a browser and look for the info on the xcache module.
     * If you see it, you have been successful!
    EOS
  end
end
