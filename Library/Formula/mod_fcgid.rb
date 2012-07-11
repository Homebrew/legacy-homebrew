require 'formula'

class ModFcgid < Formula
  homepage 'http://httpd.apache.org/mod_fcgid/'
  url 'http://apache.mesi.com.ar//httpd/mod_fcgid/mod_fcgid-2.3.7.tar.gz'
  sha1 '0914ace219c13d125e831651078610f111d970e8'
  head 'http://svn.apache.org/repos/asf/httpd/mod_fcgid/trunk'

  def install
    system "./configure.apxs"
    system "make"
    libexec.install 'modules/fcgid/.libs/mod_fcgid.so'
  end

  def caveats; <<-EOS.undent
    You must manually edit /etc/apache2/httpd.conf to contain:
      LoadModule fcgid_module #{libexec}/mod_fcgid.so
    EOS
  end

end
