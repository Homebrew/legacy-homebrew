require 'formula'

class MongoPhp < Formula
  url 'http://pecl.php.net/get/mongo-1.2.4.tgz'
  homepage 'http://pecl.php.net/package/mongo'
  md5 '307b9e5863873e49079910906470d950'

  def install
    Dir.chdir "mongo-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/mongo.so"
    end
  end

  def caveats; <<-EOS.undent
    To finish installing MongoDB extension:
     * Add the following lines to #{etc}/php.ini:
        [mongo]
        extension="#{prefix}/mongo.so"
     * Restart your webserver
    EOS
  end
end
