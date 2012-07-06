require 'formula'

class NoBdb5 < Requirement
  def message; <<-EOS.undent
    This software can fail to compile when Berkeley-DB 5.x is installed.
    You may need to try:
      brew unlink berkeley-db
      brew install exim
      brew link berkeley-db
    EOS
  end
  def satisfied?
    f = Formula.factory("berkeley-db")
    not f.installed?
  end
end

class Exim < Formula
  homepage 'http://exim.org'
  url 'http://ftp.exim.org/pub/exim/exim4/exim-4.77.tar.gz'
  sha1 '2c1ba6b8f627b71b3b58fc0cc56e394590dcd1dc'

  depends_on 'pcre'
  depends_on NoBdb5.new

  def options
    [['--support-maildir', 'Support delivery in Maildir format']]
  end

  def install
    cp 'src/EDITME', 'Local/Makefile'
    inreplace 'Local/Makefile' do |s|
      s.remove_make_var! "EXIM_MONITOR"
      s.change_make_var! "EXIM_USER", ENV['USER']
      s.change_make_var! "SYSTEM_ALIASES_FILE", etc+'aliases'
      s.gsub! '/usr/exim/configure', etc+'exim.conf'
      s.gsub! '/usr/exim', prefix
      s.gsub! '/var/spool/exim', var+'spool/exim'
      s << "SUPPORT_MAILDIR=yes\n" if ARGV.include? '--support-maildir'

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    inreplace 'OS/Makefile-Darwin' do |s|
      s.remove_make_var! %w{CC CFLAGS}
    end

    # The compile script ignores CPPFLAGS
    ENV.append "CFLAGS", ENV['CPPFLAGS']

    ENV.j1 # See: https://lists.exim.org/lurker/thread/20111109.083524.87c96d9b.en.html
    system "make"
    system "make INSTALL_ARG=-no_chown install"
    man8.install 'doc/exim.8'
    (bin+'exim_ctl').write startup_script
  end

  # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
  def startup_script; <<-EOS.undent
    #!/bin/sh
    PID=#{var}/spool/exim/exim-daemon.pid
    case "$1" in
    start)
      echo "starting exim mail transfer agent"
      #{bin}/exim -bd -q30m
      ;;
    restart)
      echo "restarting exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID` && sleep 1 && #{bin}/exim -bd -q30m
      ;;
    stop)
      echo "stopping exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID`
      ;;
    *)
      echo "Usage: #{bin}/exim_ctl {start|stop|restart}"
      exit 1
      ;;
    esac
    EOS
  end

  def caveats; <<-EOS.undent
    Start with:
      exim_ctl start
    Don't forget to run it as root to be able to bind port 25.
    EOS
  end
end
