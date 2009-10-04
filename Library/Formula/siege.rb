require 'brewkit'

class Siege <Formula
  url "ftp://ftp.joedog.org/pub/siege/siege-2.69.tar.gz"
  homepage 'http://www.joedog.org/index/siege-home'
  sha1 'f0514eefe4e024ee059b09ab50903bbced79f3b9'

  def install
    etc.mkpath
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--sysconfdir=#{etc}", "--with-ssl"
    system "make install"
  end

  def caveats; <<-EOS
You should know that macOSX has only 16K port available that won't be
released until socket TIME_WAIT is passed. Default timeout for TIME_WAIT is
15s consider reducing in case of available port bottleneck. You can check
whether there is a problem with netstat.

    $ sysctl net.inet.tcp.msl
    net.inet.tcp.msl: 15000
    $ sudo sysctl -w net.inet.tcp.msl=1000
    net.inet.tcp.msl: 15000 -> 1000

Run siege.config to create the ~/.siegerc config file.
    EOS
  end
end

