require 'formula'

class Xhprof <Formula
  url 'http://pecl.php.net/get/xhprof-0.9.2.tgz'
  homepage 'http://mirror.facebook.net/facebook/xhprof/doc.html'
  md5 'ae40b153d157e6369a32e2c1a59a61ec'

  depends_on 'pcre'

  def install
    Dir.chdir "xhprof-#{version}/extension" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install %w(modules/xhprof.so)
    end
    Dir.chdir "xhprof-#{version}" do 
      prefix.install %w(xhprof_html xhprof_lib)
    end
  end

  def caveats; <<-EOS.undent
    To finish installing XHProf:
     * Add the following lines to php.ini:
        [xhprof]
        extension="#{prefix}/xhprof.so"
     * Restart your webserver
    EOS
  end
end
