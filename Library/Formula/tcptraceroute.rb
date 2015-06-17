require 'formula'

class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage 'https://github.com/mct/tcptraceroute'
  url 'https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz'
  version '1.5beta7'
  sha1 '36b325a73d814cd62932f0def43e7d8e952474c1'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    tcptraceroute requires root privileges so you will need to run
    `sudo tcptraceroute`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
