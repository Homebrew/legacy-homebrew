require 'formula'

class MongoPhp <Formula
  head 'https://github.com/mongodb/mongo-php-driver.git', :using => :git
  homepage 'https://github.com/mongodb/mongo-php-driver'
  md5 'a79628926003bd10781968bb2bf65774'

  def install
    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install 'modules/mongo.so'
  end

  def caveats; <<-EOS.undent
    To finish installing mongodb extension:
      * Add the following line to php.ini:
        extension="#{prefix}/mongo.so"
      * Restart your webserver
    EOS
  end
end