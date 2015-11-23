class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "http://www.boutell.com/rinetd/"
  url "http://www.boutell.com/rinetd/http/rinetd.tar.gz"
  version "0.62"
  sha256 "0c68d27c5bd4b16ce4f58a6db514dd6ff37b2604a88b02c1dfcdc00fc1059898"

  bottle do
    cellar :any
    sha256 "ee8653ffad51210e68b26e6f43a34f580180aed315b050ca48cd0adcadd3e6b0" => :yosemite
    sha256 "07cbd9a185d1b3698078fd26737af105cfe31a2eb2d1a4b229e9878561f162ef" => :mavericks
    sha256 "2ed57913af533cd7778526ff633b24dbaf753558293d472d81d03ffacd9e869e" => :mountain_lion
  end

  def install
    inreplace "rinetd.c" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/rinetd.pid"
    end

    inreplace "Makefile" do |s|
      s.gsub! "/usr/sbin", sbin
      s.gsub! "/usr/man", man
    end

    sbin.mkpath
    man8.mkpath

    system "make", "install"

    conf = etc/"rinetd.conf"
    unless conf.exist?
      conf.write <<-EOS.undent
        # forwarding rules go here
        #
        # you may specify allow and deny rules after a specific forwarding rule
        # to apply to only that forwarding rule
        #
        # bindadress bindport connectaddress connectport
      EOS
    end
  end

  test do
    system "#{sbin}/rinetd", "-h"
  end
end
