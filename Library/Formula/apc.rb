require 'formula'

class Apc < Formula
  url 'http://pecl.php.net/get/APC-3.1.9.tgz'
  homepage 'http://pecl.php.net/package/apc'
  md5 'a2cf7fbf6f3a87f190d897a53260ddaa'

  depends_on 'pcre'

  def install
    Dir.chdir "APC-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"

      prefix.install %w(modules/apc.so apc.php)
    end
  end

  def caveats; <<-EOS.undent
    To finish installing APC:
     * Add the following lines to php.ini:
        [apc]
        extension="#{prefix}/apc.so"
        apc.enabled=1
        apc.shm_segments=1
        apc.shm_size=64M
        apc.ttl=7200
        apc.user_ttl=7200
        apc.num_files_hint=1024
        apc.mmap_file_mask=/tmp/apc.XXXXXX
        apc.enable_cli=1
     * Restart your webserver
     * Copy "#{prefix}/apc.php" to any site to see APC's usage.
    EOS
  end
end
