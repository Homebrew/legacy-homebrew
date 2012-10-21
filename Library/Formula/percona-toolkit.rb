require 'formula'

class PerconaToolkit < Formula
  homepage 'http://www.percona.com/software/percona-toolkit/'
  url 'http://www.percona.com/redir/downloads/percona-toolkit/2.1.5/percona-toolkit-2.1.5.tar.gz'
  sha1 '611052414a89db71ec493fe725d650112c6034fb'

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
