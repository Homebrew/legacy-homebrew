require 'formula'

class Siege <Formula
  url "ftp://ftp.joedog.org/pub/siege/siege-2.70.tar.gz"
  homepage 'http://www.joedog.org/index/siege-home'
  sha1 'ee0a0c3a9e6559cf8cbaf717649f6684b0d9643a'

  def install
    #to avoid unnecessary warning due to hardcoded path
    (prefix+'etc').mkdir
    system  "./configure",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--localstatedir=#{var}",
            "--with-ssl"
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

