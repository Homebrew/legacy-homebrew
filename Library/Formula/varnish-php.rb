require 'formula'

class VarnishPhp < Formula
  url 'http://pecl.php.net/get/varnish-0.9.1.tgz'
  homepage 'http://pecl.php.net/package/varnish'
  md5 '5be0aaeabf471f6cb4c893def912c51b'

  depends_on 'varnish'

  def install
    Dir.chdir "varnish-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/varnish.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing varnish:
      * Add the following line to php.ini:
        extension="#{prefix}/varnish.so"
      * Restart your webserver
    EOS
  end
end