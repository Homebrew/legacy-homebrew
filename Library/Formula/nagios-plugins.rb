require 'formula'

class NagiosPlugins < Formula
  homepage 'https://www.nagios-plugins.org/'
  url 'https://www.nagios-plugins.org/download/nagios-plugins-2.0.tar.gz'
  sha1 '9b9be0dfb7026d30da0e3a5bbf4040211648ee39'

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
