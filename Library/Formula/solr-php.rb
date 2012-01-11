require 'formula'

class SolrPhp < Formula
  url 'http://pecl.php.net/get/solr-1.0.1.tgz'
  homepage 'http://pecl.php.net/package/solr'
  md5 '538adecfd52a79feae777870edcfd5d7'

  def install
    Dir.chdir "solr-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/solr.so"
    end
  end

  def caveats; <<-EOS.undent
    To finish installing Solr extension:
     * Add the following lines to #{etc}/php.ini:
        [solr]
        extension="#{prefix}/solr.so"
     * Restart your webserver
    EOS
  end
end
