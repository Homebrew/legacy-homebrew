require 'formula'

class Rinetd < Formula
  url 'http://www.boutell.com/rinetd/http/rinetd.tar.gz'
  homepage 'http://www.boutell.com/rinetd/'
  md5 '28c78bac648971724c46f1a921154c4f'
  version '0.62'

  def install
    inreplace 'rinetd.c' do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/rinetd.pid"
    end

    system "make"
    bin.install "rinetd"
    man8.install "rinetd.8"
    conf = etc+"rinetd.conf"
    conf.write(conf_file) unless conf.exist?
  end

  def conf_file; <<-EOF.undent
    # forwarding rules go here
    #
    # you may specify allow and deny rules after a specific forwarding rule
    # to apply to only that forwarding rule
    #
    # bindadress bindport connectaddress connectport
    EOF
  end
end
