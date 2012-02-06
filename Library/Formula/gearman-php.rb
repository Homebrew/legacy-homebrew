require 'formula'

class GearmanPhp < Formula
  url 'http://pecl.php.net/get/gearman-0.8.0.tgz'
  homepage 'http://pecl.php.net/package/gearman'
  md5 '43fd69b1710ddb17af59c91ddeb32cb1'

  depends_on 'gearman'

  def install
    Dir.chdir "gearman-#{version}" do
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
