require 'formula'

class GearmanPhp < Formula
  homepage 'http://pecl.php.net/package/gearman'
  url 'http://pecl.php.net/get/gearman-1.0.1.tgz'
  md5 'dc576593f18e73aacf3b4430ba9d47d5'

  depends_on 'gearman'

  def install
    cd "gearman-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}",
                            "--with-gearman=#{Formula.factory('gearman').prefix}"
      system "make"
      prefix.install 'modules/gearman.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing gearman:
      * Add the following line to php.ini:
        extension="#{prefix}/gearman.so"
      * Restart your webserver
    EOS
  end
end
