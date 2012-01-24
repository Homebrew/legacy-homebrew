require 'formula'

class Graylog2Server < Formula
  url 'https://github.com/downloads/Graylog2/graylog2-server/graylog2-server-0.9.6.tar.gz'
  homepage 'http://www.graylog2.org/'
  md5 'c04257c0617555b8fec1580fbfa9ba5a'

  def install
    mv "graylog2.conf.example", "graylog2.conf"
    inreplace "graylog2.conf" do |s|
      # Better to use 127.0.0.1 instead of localhost so you
      # don't need to allow external access to MongoDB.
      # http://www.eimermusic.com/code/graylog2-on-mac-os-x/
      s.gsub! "mongodb_host = localhost", "mongodb_host = 127.0.0.1"
      s.gsub! "mongodb_useauth = true", "mongodb_useauth = false"
      s.gsub! "syslog_listen_port = 514", "syslog_listen_port = 8514"
    end

    inreplace "bin/graylog2ctl" do |s|
      s.gsub! "$NOHUP java -jar ../graylog2-server.jar &", "$NOHUP java -DconfigPath=#{etc}/graylog2.conf -jar #{prefix}/graylog2-server.jar &"
    end

    etc.install "graylog2.conf"
    prefix.install Dir['*']
  end

  def caveats
    <<-EOS.undent
      In the interest of allowing you to run `graylog2ctl`
      without `sudo`, the default port is set to 8514.

      To start graylog2-server:
        graylog2ctl start

      To stop graylog2-server:
        graylog2ctl stop

      The config file is located at:
        #{etc}/graylog2.conf
    EOS
  end

  def test
    system "#{bin}/graylog2ctl"
  end
end
