require 'formula'

class NagiosPlugins < Formula
  url 'http://downloads.sourceforge.net/project/nagiosplug/nagiosplug/1.4.15/nagios-plugins-1.4.15.tar.gz'
  homepage 'http://nagiosplugins.org/'
  md5 '56abd6ade8aa860b38c4ca4a6ac5ab0d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
  
  def caveats
    <<-EOS.undent
    All plugins reside below #{libexec}.
    You might wanna symlink to /usr/local/libexec or share for convenience:
    
      ln -s #{libexec} #{HOMEBREW_PREFIX+"libexec/nagios-plugins"}
    EOS
  end
end
