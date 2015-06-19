require 'formula'

class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage 'http://www.joedog.org/index/siege-home'
  url 'http://download.joedog.org/siege/siege-3.0.9.tar.gz'
  sha256 '82376eb466414ef4872a979a372972658df9813778ee8572341d4736ed30cb8f'

  depends_on 'openssl'

  bottle do
    sha1 "8fc40ce186470abb7b79dcae5bf0f79de19aa95a" => :yosemite
    sha1 "b4db408f279d8b22f6c0aa74577a8204d5f60678" => :mavericks
    sha1 "9d6ec76bee4bf1b145b62b5b166ffbfed5112182" => :mountain_lion
  end

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix+'etc').mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
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
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
