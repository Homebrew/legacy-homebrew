require 'formula'

class PerconaToolkit < Formula
  homepage 'http://www.percona.com/software/percona-toolkit/'
  url 'http://www.percona.com/redir/downloads/percona-toolkit/2.1.1/percona-toolkit-2.1.1.tar.gz'
  sha1 'bbaf2440c55bb62b5e98d08bd3246e82c84f6f2a'

  depends_on 'Time::HiRes' => :perl
  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  def test
    system "#{bin}/pt-archiver"
    system "#{bin}/pt-config-diff"
    system "#{bin}/pt-deadlock-logger"
    system "#{bin}/pt-duplicate-key-checker"
    system "#{bin}/pt-find"
    system "#{bin}/pt-fk-error-logger"
    system "#{bin}/pt-heartbeat"
    system "#{bin}/pt-kill"
    system "#{bin}/pt-log-player"
    system "#{bin}/pt-pmp"
    system "#{bin}/pt-slave-delay"
    system "#{bin}/pt-slave-find"
    system "#{bin}/pt-slave-restart"
    system "#{bin}/pt-summary"
    system "#{bin}/pt-table-checksum"
    system "#{bin}/pt-table-sync"
    system "#{bin}/pt-upgrade"
    system "#{bin}/pt-variable-advisor"
  end
end
