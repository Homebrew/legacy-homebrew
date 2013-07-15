require 'formula'

class PerconaToolkit < Formula
  homepage 'http://www.percona.com/software/percona-toolkit/'
  url 'http://www.percona.com/redir/downloads/percona-toolkit/2.2.2/percona-toolkit-2.2.2.tar.gz'
  sha1 '60da4d9831df9652a318fecf315884870a97d217'

  depends_on 'Time::HiRes' => :perl
  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  def test
    system "#{bin}/pt-align"
    system "#{bin}/pt-archiver"
    system "#{bin}/pt-config-diff"
    system "#{bin}/pt-deadlock-logger"
    system "#{bin}/pt-diskstats"
    system "#{bin}/pt-duplicate-key-checker"
    system "#{bin}/pt-fifo-split"
    system "#{bin}/pt-find"
    system "#{bin}/pt-fingerprint"
    system "#{bin}/pt-fk-error-logger"
    system "#{bin}/pt-heartbeat"
    system "#{bin}/pt-index-usage"
    system "#{bin}/pt-ioprofile"
    system "#{bin}/pt-kill"
    system "#{bin}/pt-mext"
    system "#{bin}/pt-mysql-summary"
    system "#{bin}/pt-online-schema-change"
    system "#{bin}/pt-pmp"
    system "#{bin}/pt-query-digest"
    system "#{bin}/pt-show-grants"
    system "#{bin}/pt-sift"
    system "#{bin}/pt-slave-delay"
    system "#{bin}/pt-slave-find"
    system "#{bin}/pt-slave-restart"
    system "#{bin}/pt-stalk"
    system "#{bin}/pt-summary"
    system "#{bin}/pt-table-checksum"
    system "#{bin}/pt-table-sync"
    system "#{bin}/pt-table-usage"
    system "#{bin}/pt-upgrade"
    system "#{bin}/pt-variable-advisor"
    system "#{bin}/pt-visual-explain"
  end
end
