require 'formula'

class Vnstat < Formula
  url 'http://humdi.net/vnstat/vnstat-1.10.tar.gz'
  homepage 'http://humdi.net/vnstat/'
  md5 '95421d968689130590348ceb80ff74a8'

  def install
    inreplace ["src/cfg.c", "man/vnstat.1", "man/vnstatd.1", "man/vnstat.conf.5"] do |s|
      s.gsub!('/etc/vnstat.conf',    "#{etc}/vnstat.conf")
      s.gsub!('/var/lib/vnstat',     "#{var}/db/vnstat")
      s.gsub!('/var/log/vnstat.log', "#{var}/log/vnstat.log")
      s.gsub!('/var/run/vnstat.pid', "#{var}/run/vnstat.pid")
    end

    inreplace "src/Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CC", ENV.cc
    end

    inreplace "cfg/vnstat.conf" do |c|
      c.gsub!('DatabaseDir "/var/lib/vnstat"', %Q{DatabaseDir "#{var}/db/vnstat"})
      c.gsub!('LogFile "/var/log/vnstat.log"', %Q{LogFile "#{var}/log/vnstat.log"})
      c.gsub!('PidFile "/var/run/vnstat.pid"', %Q{PidFile "#{var}/run/vnstat.pid"})
    end

    (var + 'db/vnstat').mkpath
    (var + 'spool/vnstat').mkpath

    system "make -C src"
    (prefix + 'etc').install "cfg/vnstat.conf"
    bin.install "src/vnstat"
    bin.install "src/vnstatd"
    man1.install "man/vnstat.1"
    man1.install "man/vnstatd.1"
    man5.install "man/vnstat.conf.5"
  end

  def caveats; <<-MSG
    To setup vnstat, run `vnstat -u -i en0' (replace en0 with the network
    interface you wish to monitor).

    You must then create a cron job to update the vnstat database.

    Run `crontab -e', and add the following:
    0-55/5 * * * * if [ -x #{bin}/vnstat ] && [ `ls #{var}/db/vnstat/ | wc -l` -ge 1 ]; then #{bin}/vnstat -u; fi
    MSG
  end
end
