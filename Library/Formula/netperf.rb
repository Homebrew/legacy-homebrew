require 'formula'

class Netperf < Formula
  homepage 'http://netperf.org'
  url 'ftp://ftp.netperf.org/netperf/netperf-2.6.0.tar.bz2'
  sha1 '3e1be4e7c3f7a838c4d5c00c6d20a619b320bfef'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    #avoid disrupting existing netserver processes during testing
    netserver_running = `ps aux | grep netserve[r]` != ""

    unless netserver_running
      fork do
        system "netserver"
      end
    end

    system "netperf"
    system "killall netserver" unless netserver_running
  end
end
