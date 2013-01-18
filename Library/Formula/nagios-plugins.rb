require 'formula'

class NagiosPlugins < Formula
  homepage 'http://nagiosplugins.org/'
  url 'http://nagiosplug.sourceforge.net/snapshot/nagios-plugins-1.4.16-61-g1845c.tar.gz'
  sha1 '00ec47a3289baed3b550c57127371047936eb8e3'

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
