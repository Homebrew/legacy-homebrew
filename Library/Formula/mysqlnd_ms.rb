require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class MysqlndMs < AbstractPhp54Extension
  homepage 'http://pecl.php.net/package/mysqlnd_ms'
  url 'http://pecl.php.net/get/mysqlnd_ms-1.4.2.tgz'
  sha1 'b074ee9f696ec17422638e1d554a0665320f4df9'
  head 'https://svn.php.net/repository/pecl/mysqlnd_ms/trunk/', :using => :svn

  depends_on 'php54'
  depends_on 'autoconf' => :build

  def php_branch
    "5.4"
  end
  def extension
    "mysqlnd_ms"
  end


  def install
    Dir.chdir extension + "-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    system "phpize"
    system "./configure", "--prefix=#{prefix}", phpconfig, "--enable-mysqlnd-ms"

    system "make"
    prefix.install "modules/" + extension + ".so"
    write_config_file unless build.include? "without-config-file"
  end
end
