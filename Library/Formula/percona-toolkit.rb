require 'formula'

class PerconaToolkit < Formula
  url 'http://www.percona.com/redir/downloads/percona-toolkit/percona-toolkit-1.0.1.tar.gz'
  homepage 'http://www.percona.com/software/percona-toolkit/'
  md5 '1d843b1b3ebd2eacfa3bf95ef2a00557'

  depends_on 'Time::HiRes' => :perl
  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  def test
    system "pt-archiver"
    system "pt-config-diff"
    system "pt-deadlock-logger"
    system "pt-duplicate-key-checker"
    system "pt-find"
    system "pt-fk-error-logger"
    system "pt-heartbeat"
    system "pt-kill"
    system "pt-log-player"
    system "pt-pmp"
    system "pt-slave-delay"
    system "pt-slave-find"
    system "pt-slave-restart"
    system "pt-summary"
    system "pt-table-checksum"
    system "pt-table-sync"
    system "pt-upgrade"
    system "pt-variable-advisor"
  end
end
