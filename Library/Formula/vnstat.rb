require 'formula'

class Vnstat < Formula
  homepage 'http://humdi.net/vnstat/'
  url 'http://humdi.net/vnstat/vnstat-1.11.tar.gz'
  sha1 '92494f38a752dcf60053af2a6d8977737da7e616'

  def install
    inreplace "src/cfg.c", '/etc/vnstat.conf', "#{etc}/vnstat.conf"

    inreplace "man/vnstat.1" do |s|
      s.gsub! '/etc/vnstat.conf', "#{etc}/vnstat.conf"
      s.gsub! '/var/lib/vnstat', "#{var}/db/vnstat"
    end

    inreplace "man/vnstat.conf.5", '/etc/vnstat.conf', "#{etc}/vnstat.conf"

    inreplace "cfg/vnstat.conf" do |c|
      c.gsub! 'DatabaseDir "/var/lib/vnstat"', %Q{DatabaseDir "#{var}/db/vnstat"}
      c.gsub! 'LogFile "/var/log/vnstat.log"', %Q{LogFile "#{var}/log/vnstat.log"}
      c.gsub! 'PidFile "/var/run/vnstat.pid"', %Q{PidFile "#{var}/run/vnstat.pid"}
    end

    (var+'db/vnstat').mkpath
    (var+'spool/vnstat').mkpath

    system "make", "-C", "src", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    (prefix+'etc').install "cfg/vnstat.conf"
    bin.install "src/vnstat", "src/vnstatd"
    man1.install "man/vnstat.1", "man/vnstatd.1"
    man5.install "man/vnstat.conf.5"
  end

  def caveats; <<-EOS.undent
    To setup vnstat, run `vnstat -u -i en0' (replace en0 with the network
    interface you wish to monitor).

    You must then create a cron job to update the vnstat database.

    Run `crontab -e' and add the following:
    0-55/5 * * * * if [ -x #{bin}/vnstat ] && [ `ls #{var}/db/vnstat/ | wc -l` -ge 1 ]; then #{bin}/vnstat -u; fi
    EOS
  end
end
