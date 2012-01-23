require 'formula'

class MongoPhp < Formula
  url 'http://pecl.php.net/get/mongo-1.2.6.tgz'
  homepage 'http://pecl.php.net/package/mongo'
  md5 'b471f3d9309c2caa52ea90122042d3f4'

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
