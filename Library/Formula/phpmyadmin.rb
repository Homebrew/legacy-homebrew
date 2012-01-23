require 'formula'

class Phpmyadmin < Formula
  url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.4.7/phpMyAdmin-3.4.7-all-languages.tar.gz'
  homepage 'http://www.phpmyadmin.net/documentation'
  md5 'b422d003ed6239bc9f96c02af6c66405'
  version '3.4.7'

  depends_on 'mcrypt-php'

  def install
    (share+'phpmyadmin').install Dir['*']
  end

  def caveats; <<-EOS.undent
    Note that this formula will NOT install mysql. It is not
    required since you might want to get connected to a remote
    database server.

    Webserver configuration example (add this at the end of
    your /etc/apache2/httpd.conf for instance) :
      Alias /phpmyadmin #{HOMEBREW_PREFIX}/share/phpmyadmin
      <Directory #{HOMEBREW_PREFIX}/share/phpmyadmin/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>
    Then, open http://localhost/phpmyadmin

    More documentation : file://#{share}/phpmyadmin/Documentation.html
    EOS
  end
end
