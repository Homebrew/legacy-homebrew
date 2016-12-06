require 'formula'

class ModFastcgi < Formula
  url 'http://www.fastcgi.com/dist/mod_fastcgi-2.4.6.tar.gz'
  homepage 'http://www.fastcgi.com/'
  md5 'a21a613dd5dacf4c8ad88c8550294fed'

  def install
    target_arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    system "cp Makefile.AP2 Makefile"
    system "make top_dir=/usr/share/httpd CFLAGS=\"-mmacosx-version-min=#{MACOS_VERSION} -isysroot #{MacOS.xcode_prefix}/SDKs/MacOSX#{MACOS_VERSION}.sdk -arch #{target_arch}\""
    libexec.install '.libs/mod_fastcgi.so'
  end

  def caveats; <<-EOS.undent
    You must manually edit /etc/apache2/httpd.conf to contain:
      LoadModule fastcgi_module #{libexec}/mod_fastcgi.so

    Upon restarting Apache, you should see the following message in the error log:
      [notice] FastCGI: process manager initialized
    EOS
  end

  def test
    system "ls #{libexec}/mod_fastcgi.so"
  end
end
