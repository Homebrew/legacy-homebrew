require 'formula'

class Midgard2Php < Formula
  url 'http://www.midgard-project.org/midcom-serveattachmentguid-025abaac43f811e0b064792d116f21f421f4/php5-midgard2-10.05.4.tar.gz'
  head 'git://github.com/midgardproject/midgard-php5.git', :branch => 'ratatoskr'
  homepage 'http://www.midgard-project.org/'
  md5 'a715d76abdb6ef1bb5eb8c9973fbba16'

  depends_on 'pkg-config' => :build
  depends_on 'midgard2'

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
