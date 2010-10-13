require 'formula'

class Xdebug <Formula
  url 'http://xdebug.org/files/xdebug-2.1.0.tgz'
  homepage 'http://xdebug.org'
  md5 '2abf000f8d94af469773b31772aa96ab'

  def install
    Dir.chdir "xdebug-#{version}" do
      # See http://github.com/mxcl/homebrew/issues/#issue/69
      ENV.universal_binary unless Hardware.is_64_bit?

      system "phpize"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--enable-xdebug"
      system "make"
      prefix.install 'modules/xdebug.so'
    end
  end

  def caveats
      <<-EOS
To use this software:
 * Add the following line to php.ini:
    zend_extension="#{prefix}/xdebug.so"
 * Restart your webserver.
 * Write a PHP page that calls "phpinfo();"
 * Load it in a browser and look for the info on the xdebug module.
 * If you see it, you have been successful!
      EOS
  end
end
