require 'formula'

class NagiosPlugins < Formula
  homepage 'https://www.nagios-plugins.org/'
  url 'https://www.nagios-plugins.org/download/nagios-plugins-2.0.1.tar.gz'
  sha1 'b895cd3758902582230d8a4eb0ce18318b4189c6'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{sbin}"
    system "make install"
    system "make install-root"
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end
end
