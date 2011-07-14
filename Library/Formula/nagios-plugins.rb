require 'formula'

class NagiosPlugins < Formula
  url 'http://downloads.sourceforge.net/project/nagiosplug/nagiosplug/1.4.15/nagios-plugins-1.4.15.tar.gz'
  homepage 'http://nagiosplugins.org/'
  md5 '56abd6ade8aa860b38c4ca4a6ac5ab0d'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin+'nagios-plugins'}"
    system "make install"
  end
  
  def caveats
    <<-EOS.undent
    All plugins are accessible under
    
      /usr/local/sbin/nagios-plugins
    
    so that they don't appear in your search path but still can be found by
    nagios across version updates.
    
    Please feel free to update your PATH if you want to use them standalone!
    EOS
  end
end
