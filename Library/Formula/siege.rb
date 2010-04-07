require 'formula'

class Siege <Formula
  url "ftp://ftp.joedog.org/pub/siege/siege-2.69.tar.gz"
  homepage 'http://www.joedog.org/index/siege-home'
  sha1 'f0514eefe4e024ee059b09ab50903bbced79f3b9'

  def etc
    # NOTE this is because line 101 in init.c in the source code of Siege
    # ignores the --sysconfdir setting, and instead looks here.
    # So coupled with the fact the etc directory location is a little up in the
    # air currently. This seems like the best solution for now.
    prefix+'etc'
  end

  def install
    etc.mkpath
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--sysconfdir=#{etc}", "--with-ssl"
    system "make install"
  end

  def caveats; <<-EOS
Mac OS X has only 16K ports available that won't be released until socket
TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds. Consider
reducing in case of available port bottleneck. You can check whether tis is a
problem with netstat.

    $ sysctl net.inet.tcp.msl
    net.inet.tcp.msl: 15000
    $ sudo sysctl -w net.inet.tcp.msl=1000
    net.inet.tcp.msl: 15000 -> 1000

Run siege.config to create the ~/.siegerc config file.
    EOS
  end
end

