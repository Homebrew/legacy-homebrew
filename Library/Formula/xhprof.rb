require 'formula'

class Xhprof < Formula
  url 'https://nodeload.github.com/facebook/xhprof/tarball/master'
  homepage 'https://nodeload.github.com/facebook/xhprof/tarball/master'
  md5 'c02c5e5477a232677e8c9ebab8aed66a'
  version '2011.07.17'

  def install
    Dir.chdir "extension" do
      system "phpize"
      php_config = `which php-config`
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-php-config=#{php_config}"
      system "make"
      prefix.install 'modules/xhprof.so'
    end
  end

  def caveats; <<-EOS.undent
    To use this software:
      * Add the following line to php.ini:
        [xhprof]
        extension="#{prefix}/xhprof.so"
        xhprof.output_dir="/var/tmp/xhprof"
      * Make the /var/tmp/xhprof folder writable
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the xdebug module.
        If you see it, you have been successful!
      * Read this: http://techportal.ibuildings.com/2009/12/01/profiling-with-xhprof/
    EOS
  end
end
