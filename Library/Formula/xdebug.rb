require 'brewkit'

class Xdebug <Formula
  url 'http://xdebug.org/files/xdebug-2.0.5.tgz'
  homepage 'http://xdebug.org'
  md5 '2d87dab7b6c499a80f0961af602d030c'

  def install
    Dir.chdir 'xdebug-2.0.5' do
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

      Write a PHP page that calls "phpinfo();" Load it in a browser and
      look for the info on the xdebug module.  If you see it, you have been
      successful!
      END_CAVEATS
  end
end
