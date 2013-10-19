require 'formula'

class NagiosPlugins < Formula
  homepage 'https://www.nagios-plugins.org/'
  url 'https://www.nagios-plugins.org/download/nagios-plugins-1.4.16.tar.gz'
  sha1 '52db48b15572b98c6fcd8aaec2ef4d2aad7640d3'

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
