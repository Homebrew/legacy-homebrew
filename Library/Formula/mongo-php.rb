require 'formula'

class MongoPhp < Formula
  url 'http://pecl.php.net/get/mongo-1.2.2.tgz'
  homepage 'http://pecl.php.net/package/mongo'
  md5 'b589a922222bfe5a13e5b18359e87437'

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
