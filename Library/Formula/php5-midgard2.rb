require 'formula'

class Php5Midgard2 <Formula
  url 'http://www.midgard-project.org/midcom-serveattachmentguid-307e30ac335f11e0bf6851688cf9977f977f/php5-midgard2-10.05.3.tar.gz'
  head 'git://github.com/midgardproject/midgard-php5.git', :branch => 'ratatoskr'
  homepage 'http://www.midgard-project.org/'
  md5 '96035da694db8572542346e1af2f29f2'

  depends_on 'pkg-config'
  depends_on 'midgard2-core'

  def install
    system "/usr/bin/phpize"
    system "./configure", "--with-php-config=/usr/bin/php-config"

    system "make"
    prefix.install 'modules/midgard2.so'
  end

  def caveats
   <<-END_CAVEATS
 * Add the following line to php.ini:
    extension="#{prefix}/midgard2.so"
 * Restart your webserver.
 * Write a PHP page that calls "phpinfo();"
 * Load it in a browser and look for the info on the midgard2 module.
 * If you see it, you have been successful!
    END_CAVEATS
  end
end
