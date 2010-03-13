require 'formula'

class Xdebug <Formula
  url 'http://xdebug.org/files/xdebug-2.1.0beta3.tgz'
  homepage 'http://xdebug.org'
  md5 '51eff76e85280ea14860bcf7dbffa899'
  version '2.1.0beta3'

  def install
    Dir.chdir 'xdebug-2.1.0beta3' do
      # See http://github.com/mxcl/homebrew/issues/#issue/69
      ENV.universal_binary unless Hardware.is_64_bit?

      system "phpize"
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
                            "--enable-xdebug"
      system "make"
      prefix.install 'modules/xdebug.so'
    end
  end

  def caveats
      <<-END_CAVEATS
Add the following line to php.ini:

    zend_extension="#{prefix}/xdebug.so"

Restart your webserver.

Write a PHP page that calls "phpinfo();" Load it in a browser and look for the
info on the xdebug module.  If you see it, you have been successful!
      END_CAVEATS
  end
end
