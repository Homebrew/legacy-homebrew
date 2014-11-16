require 'formula'

class Siege < Formula
  homepage 'http://www.joedog.org/index/siege-home'
  url 'http://download.joedog.org/siege/siege-3.0.7.tar.gz'
  sha256 'c651e2ae871cc680eb375f128b4809e97ceecf367f6bd65c3df00603fbceed4e'

  bottle do
    sha1 "b20c74de2adcdae43e88fbca22fc01fcf58b5285" => :mavericks
    sha1 "1763b8658f43dbe0bc29fd22278582372db67937" => :mountain_lion
    sha1 "341a530677f23ae7a871c7278e3ded0d2382bc77" => :lion
  end

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix+'etc').mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Mac OS X has only 16K ports available that won't be released until socket
    TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
    Consider reducing in case of available port bottleneck.

    You can check whether this is a problem with netstat:

        # sysctl net.inet.tcp.msl
        net.inet.tcp.msl: 15000

        # sudo sysctl -w net.inet.tcp.msl=1000
        net.inet.tcp.msl: 15000 -> 1000

    Run siege.config to create the ~/.siegerc config file.
    EOS
  end

  test do
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "http://google.com/"
  end
end
