require 'formula'

class SphinxPHP <Formula
  url 'http://pecl.php.net/get/sphinx-1.1.0.tgz'
  homepage 'http://pecl.php.net/package/sphinx'
  md5 '8997229134fabb77b224ec7507965347'

  def install
    Dir.chdir "sphinx-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/sphinx.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing sphinx extension:
      * Add the following line to php.ini:
        extension="#{prefix}/sphinx.so"
      * Restart your webserver
    EOS
  end
end