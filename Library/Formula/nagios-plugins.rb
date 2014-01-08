require 'formula'

class NagiosPlugins < Formula
  homepage 'https://www.nagios-plugins.org/'
  url 'https://www.nagios-plugins.org/download/nagios-plugins-1.5.tar.gz'
  sha1 '5d426b0e303a5201073c342d8ddde8bafca1432b'

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
